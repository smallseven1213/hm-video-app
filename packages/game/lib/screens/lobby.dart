import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:game/controllers/game_list_controller.dart';
import 'package:game/controllers/game_param_config_controller.dart';
import 'package:game/controllers/game_wallet_controller.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:game/screens/lobby/floating_button/game_envelope_button.dart';
import 'package:game/screens/lobby/game_carousel.dart';
import 'package:game/screens/lobby/game_list/list_view/index.dart';
import 'package:game/screens/lobby/login_tabs.dart';
import 'package:game/screens/user_info/game_user_info.dart';
import 'package:game/screens/user_info/game_user_info_deposit.dart';
import 'package:game/screens/user_info/game_user_info_service.dart';
import 'package:game/screens/user_info/game_user_info_withdraw.dart';
import 'package:game/utils/loading.dart';
import 'package:game/utils/show_model.dart';
import 'package:game/widgets/draggable_button.dart';
import 'package:game/widgets/maintenance.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/game_platform_config_controller.dart';
import 'package:shared/controllers/user_controller.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/utils/event_bus.dart';

import '../enums/game_app_routes.dart';
import '../localization/game_localization_delegate.dart';

final logger = Logger();

class GameLobby extends StatefulWidget {
  final bool? hideAppBar;
  final String? bottom;
  const GameLobby({Key? key, this.hideAppBar, this.bottom}) : super(key: key);

  @override
  State<GameLobby> createState() => _GameLobbyState();
}

class CustomFabPosition extends FloatingActionButtonLocation {
  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    return Offset(scaffoldGeometry.scaffoldSize.width * .8, 430);
  }
}

class _GameLobbyState extends State<GameLobby>
    with SingleTickerProviderStateMixin {
  final localStorage = GetStorage();

  bool isShowGameList = false;
  bool updatedUserInfo = false;
  List gameHistoryList = [];
  bool isShowFab = false;
  bool isShowDownload = true;

  UserController userController = Get.find<UserController>();
  GameWalletController gameWalletController = Get.find<GameWalletController>();
  GameParamConfigController gameParamConfigController =
      Get.find<GameParamConfigController>();
  GamePlatformConfigController gameConfigController =
      Get.find<GamePlatformConfigController>();
  GamesListController gamesListController = Get.find<GamesListController>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchEvent();
    });
  }

  void _fetchEvent() async {
    String? event = eventBus.getLatestEvent();
    if (event == "gotoDepositAfterLogin" && mounted) {
      if (gameConfigController.videoToGameRoute.value != '') {
        // 進入遊戲大廳之外的遊戲頁面
        logger.i(
            'videoToGameRoute: ${gameConfigController.videoToGameRoute.value}');
        MyRouteDelegate.of(context).push(
          gameConfigController.videoToGameRoute.value,
          removeSamePath: true,
        );
      } else {
        // 進入存款頁
        MyRouteDelegate.of(context)
            .push(gameConfigController.depositRoute.value);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final GameLocalizations localizations = GameLocalizations.of(context)!;

    return Obx(() => gamesListController.isMaintenance.value == true
        ? const GameMaintenance()
        : Scaffold(
            appBar: widget.hideAppBar == true
                ? null
                : AppBar(
                    backgroundColor: gameLobbyBgColor,
                    centerTitle: true,
                    title: Text(
                      localizations.translate('game_lobby'),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: gameLobbyAppBarTextColor,
                      ),
                    ),
                    // 如果roles是'guest'，就顯示登入按鈕
                    actions: userController.info.value.roles.contains('guest')
                        ? [
                            InkWell(
                              onTap: () {
                                showModel(
                                  context,
                                  content: GameLobbyLoginTabs(
                                    type: Type.login,
                                    onSuccess: () {
                                      // userController.fetchUserInfo();
                                      gameWalletController
                                          .fetchWalletsInitFromThirdLogin();

                                      Navigator.pop(context);
                                    },
                                  ),
                                  onClosed: () => Navigator.pop(context),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Container(
                                  width: 85,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    color: gamePrimaryButtonColor,
                                  ),
                                  child: Center(
                                    child: Text(
                                      localizations.translate('register_login'),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: gamePrimaryButtonTextColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ]
                        : null,
                  ),
            body: OrientationBuilder(
              builder: (BuildContext context, Orientation orientation) {
                return SafeArea(
                  child: Stack(
                    children: [
                      Container(
                        color: gameLobbyBgColor,
                        height: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 16),
                        child: Column(
                          children: [
                            const GameCarousel(),
                            GameUserInfo(
                              type: 'lobby',
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // 存款
                                  UserInfoDeposit(
                                    onTap: () {
                                      MyRouteDelegate.of(context).push(
                                          gameConfigController
                                              .depositRoute.value);
                                    },
                                  ),
                                  // 提現
                                  UserInfoWithdraw(
                                    onTap: () => MyRouteDelegate.of(context)
                                        .push(GameAppRoutes.withdraw),
                                  ),
                                  // 客服
                                  const UserInfoService(),
                                ],
                              ),
                            ),
                            Obx(
                              () => gamesListController
                                      .gamePlatformList.value.isNotEmpty
                                  ? const GameListView()
                                  : const GameLoading(),
                            ),
                          ],
                        ),
                      ),
                      Obx(
                        () => Positioned(
                          bottom: 35,
                          right: 15,
                          child: Column(
                            children: [
                              // 紅包icon
                              if (gameConfigController.isShowEnvelope.value ==
                                      true &&
                                  userController.info.value.roles
                                      .contains('guest'))
                                GameEnvelopeButton(
                                  hasDownload: !kIsWeb &&
                                      gameParamConfigController
                                              .appDownload.value ==
                                          'true' &&
                                      isShowDownload &&
                                      !localStorage
                                          .hasData('show-app-download'),
                                ),
                              // 下載直營app icon
                              // if (!kIsWeb &&
                              //     gameParamConfigController.appDownload.value ==
                              //         'true' &&
                              //     isShowDownload &&
                              //     !localStorage.hasData('show-app-download'))
                              //   GameDownloadButton(
                              //     setShowFab: () => setState(() {
                              //       isShowDownload = false;
                              //     }),
                              //   ),
                            ],
                          ),
                        ),
                      ),
                      // 熱門活動icon
                      Obx(
                        () =>
                            gameParamConfigController.activityEntrance.value ==
                                    'true'
                                ? DraggableFloatingActionButton(
                                    initialOffset: Offset(
                                      MediaQuery.of(context).size.width - 70,
                                      MediaQuery.of(context).size.height - 290,
                                    ),
                                    child: InkWell(
                                      onTap: () => MyRouteDelegate.of(context)
                                          .push(GameAppRoutes.activity),
                                      child: Image.asset(
                                        'packages/game/assets/images/game_lobby/gift.webp',
                                        width: 64,
                                        height: 64,
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                );
              },
            ),
          ));
  }
}
