import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:game/controllers/game_config_controller.dart';
import 'package:game/models/game_list.dart';
import 'package:game/screens/game_webview_screen/game_webview_toggle_button.dart';
import 'package:game/widgets/draggable_button.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

import 'package:shared/navigator/delegate.dart';

import 'package:game/services/game_system_config.dart';
import 'package:game/utils/showConfirmDialog.dart';
import 'package:game/widgets/h5webview.dart';

import '../../enums/game_app_routes.dart';

final logger = Logger();

class GameLobbyWebview extends StatefulWidget {
  final String gameUrl;
  final int direction;
  const GameLobbyWebview(
      {Key? key, required this.gameUrl, required this.direction})
      : super(key: key);

  @override
  State<GameLobbyWebview> createState() => _GameLobbyWebview();
}

class ButtonWidget extends StatefulWidget {
  final Function toggleButtonRow;
  const ButtonWidget({
    Key? key,
    required this.toggleButtonRow,
  }) : super(key: key);

  @override
  State<ButtonWidget> createState() => _ButtonWidget();
}

// 建立一個ButtonWidget，用來放兩個floatingActionButton
class _ButtonWidget extends State<ButtonWidget> {
  final systemConfig = GameSystemConfig();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final gameConfigController = Get.put(GameConfigController());

    return PointerInterceptor(
      child: RotatedBox(
        quarterTurns: orientation == Orientation.portrait ? 1 : 0,
        child: Container(
          height: 88,
          width: 288,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  logger.i('返回大廳');
                  showConfirmDialog(
                    context: context,
                    title: '退出遊戲',
                    content: '你真的要退出遊戲嗎？',
                    rotate: orientation == Orientation.portrait ? true : false,
                    onConfirm: () {
                      Navigator.of(context).pop();
                      MyRouteDelegate.of(context).popRoute();
                    },
                    onCancel: () {
                      MyRouteDelegate.of(context).popRoute();
                    },
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'packages/game/assets/svg/icon-game-home.svg',
                      width: 32,
                      height: 32,
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "返回大廳",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontFeatures: [FontFeature.proportionalFigures()],
                      ),
                    ), // <-- Text
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  launch(
                      '${systemConfig.apiHost}/public/domains/domain/customer-services');
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'packages/game/assets/svg/icon-game-service.svg',
                      width: 32,
                      height: 32,
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "客服",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ), // <-- Text
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  logger.i('充值');
                  Navigator.of(context).pop();
                  MyRouteDelegate.of(context).push(
                    gameConfigController.switchPaymentPage.value ==
                            switchPaymentPageType['list']
                        ? GameAppRoutes.depositList.value
                        : GameAppRoutes.depositPolling.value,
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'packages/game/assets/svg/icon-game-deposit.svg',
                      width: 32,
                      height: 32,
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "充值",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ), // <-- Text
                  ],
                ),
              ),
              InkWell(
                onTap: () => widget.toggleButtonRow(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'packages/game/assets/svg/icon-game-close.svg',
                      width: 32,
                      height: 32,
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "關閉",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ), // <-- Text
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GameLobbyWebview extends State<GameLobbyWebview> {
  bool toggleButton = false;
  final GlobalKey _parentKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  toggleButtonRow() {
    logger.i('toggleButtonRow');
    setState(() {
      toggleButton = !toggleButton;
    });
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      body: Stack(
        key: _parentKey,
        children: [
          H5Webview(
            initialUrl: widget.gameUrl,
            direction: widget.direction,
          ),
          if (!GetPlatform.isWeb)
            Center(
              child: toggleButton
                  ? PointerInterceptor(
                      child: GameWebviewToggleButtonWidget(
                      toggleButtonRow: () => toggleButtonRow(),
                      direction: widget.direction,
                    ))
                  : Container(),
            ),
          if (!GetPlatform.isWeb)
            DraggableFloatingActionButton(
              initialOffset:
                  widget.direction == gameWebviewDirection['vertical']
                      ? Offset(Get.width - 70, Get.height - 70)
                      : Offset(20, Get.height - 70),
              parentKey: _parentKey,
              child: RotatedBox(
                quarterTurns:
                    widget.direction == gameWebviewDirection['vertical']
                        ? (orientation == Orientation.portrait ? 0 : 1)
                        : (orientation == Orientation.portrait ? 1 : 0),
                child: PointerInterceptor(
                  child: InkWell(
                    onTap: () => toggleButtonRow(),
                    child: GestureDetector(
                      child: SizedBox(
                        width: 55,
                        height: 55,
                        child: Image.asset(
                          'packages/game/assets/images/game_lobby/icons-menu.webp',
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
