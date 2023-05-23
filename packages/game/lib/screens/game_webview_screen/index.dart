import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:game/controllers/game_config_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

import 'package:shared/navigator/delegate.dart';

import 'package:game/services/game_system_config.dart';
import 'package:game/utils/showConfirmDialog.dart';
import 'package:game/widgets/h5webview.dart';

import '../../enums/game_app_routes.dart';

class GameLobbyWebview extends StatefulWidget {
  final String gameUrl;
  const GameLobbyWebview({Key? key, required this.gameUrl}) : super(key: key);

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
                  print('返回大廳');
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
                  print('充值');
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
  String gameUrl = '';
  bool toggleButton = false;
  final GlobalKey _parentKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  toggleButtonRow() {
    print('toggleButtonRow');
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
          ),
          Positioned(
            top: orientation == Orientation.portrait
                ? Get.height / 2 - 144
                : Get.height / 2 - 44,
            left: orientation == Orientation.portrait
                ? Get.width / 2 - 44
                : Get.width / 2 - 144,
            child: toggleButton
                ? ButtonWidget(
                    toggleButtonRow: () => toggleButtonRow(),
                  )
                : Container(),
          ),
          Positioned(
            top: 20,
            left: 10,
            child: RotatedBox(
              quarterTurns: orientation == Orientation.portrait ? 1 : 0,
              child: PointerInterceptor(
                child: GestureDetector(
                  onTap: () {
                    toggleButtonRow();
                  },
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
        ],
      ),
    );
  }
}
