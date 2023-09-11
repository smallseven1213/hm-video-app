import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import 'package:game/screens/lobby/game_carousel.dart';
import 'package:game/screens/lobby/game_list_view.dart';
import 'package:game/screens/lobby/game_marquee.dart';
import 'package:game/screens/lobby/login_tabs.dart';

import 'package:game/apis/game_api.dart';
import 'package:game/utils/show_model.dart';
import 'package:game/widgets/maintenance.dart';
import 'package:game/models/game_list.dart';

import 'package:shared/controllers/auth_controller.dart';
import 'package:shared/controllers/user_controller.dart';
import 'package:shared/navigator/delegate.dart';

import 'package:game/controllers/game_config_controller.dart';
import 'package:game/controllers/game_list_controller.dart';
import 'package:game/controllers/game_banner_controller.dart';
import 'package:game/controllers/game_wallet_controller.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:game/screens/user_info/game_user_info.dart';
import 'package:game/screens/user_info/game_user_info_deposit.dart';
import 'package:game/screens/user_info/game_user_info_service.dart';
import 'package:game/screens/user_info/game_user_info_withdraw.dart';

import '../enums/game_app_routes.dart';

final logger = Logger();

class GameLobby extends StatefulWidget {
  final String? bottom;
  const GameLobby({Key? key, this.bottom}) : super(key: key);

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
  bool isShowGameList = false;
  bool updatedUserInfo = false;
  List<GameItem> gameList = [];
  List gameHistoryList = [];
  bool isShowFab = false;
  TabController? _tabController;

  UserController get userController => Get.find<UserController>();
  GameWalletController gameWalletController = Get.find<GameWalletController>();

  @override
  void initState() {
    super.initState();
    _fetchDataInit();
    _tabController = TabController(length: 3, vsync: this);

    Get.find<AuthController>().token.listen((event) {
      _fetchDataInit();
      userController.fetchUserInfo();
      gameWalletController.fetchWallets();
      logger.i('token changed');
    });
  }

  _fetchDataInit() {
    Future.wait([
      GameLobbyApi().registerGame(),
    ]).then((value) {
      GameBannerController();
    });
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameBannerController = Get.put(GameBannerController());
    final gameWalletController = GameWalletController();
    final gameConfigController = Get.put(GameConfigController());
    final gamesListController = Get.put(GamesListController());

    return Obx(() => gamesListController.isMaintenance.value == true
        ? const GameMaintenance()
        : Scaffold(
            appBar: AppBar(
              leading: Container(),
              backgroundColor: gameLobbyBgColor,
              centerTitle: true,
              title: Text(
                '游戏大厅',
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
                                userController.fetchUserInfo();
                                gameWalletController.mutate();
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
                                '註冊/登入',
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
                  child: Container(
                    color: gameLobbyBgColor,
                    height: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                    child: Column(
                      children: <Widget>[
                        // GameCarousel(data: gameBannerController.gameBanner),
                        GameMarquee(data: gameBannerController.gameMarquee),
                        GameUserInfo(
                          type: 'lobby',
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // 存款
                              UserInfoDeposit(
                                onTap: () {
                                  MyRouteDelegate.of(context).push(
                                    gameConfigController
                                                .switchPaymentPage.value ==
                                            switchPaymentPageType['list']
                                        ? GameAppRoutes.depositList.value
                                        : GameAppRoutes.depositPolling.value,
                                  );
                                },
                              ),
                              // 提現
                              UserInfoWithdraw(
                                onTap: () {
                                  MyRouteDelegate.of(context).push(
                                    GameAppRoutes.withdraw.value,
                                  );
                                },
                              ),
                              // 客服
                              const UserInfoService(),
                            ],
                          ),
                        ),
                        const GameListView(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ));
  }
}
