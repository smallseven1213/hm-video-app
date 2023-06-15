import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:game/controllers/game_config_controller.dart';
import 'package:game/enums/game_app_routes.dart';
import 'package:game/models/game_list.dart';
import 'package:game/services/game_system_config.dart';
import 'package:game/utils/show_confirm_dialog.dart';
import 'package:game/widgets/game_startup.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:url_launcher/url_launcher.dart';

final logger = Logger();

class GameWebviewToggleButtonWidget extends StatefulWidget {
  final Function toggleButtonRow;
  final int direction;

  const GameWebviewToggleButtonWidget({
    Key? key,
    required this.toggleButtonRow,
    required this.direction,
  }) : super(key: key);

  @override
  State<GameWebviewToggleButtonWidget> createState() =>
      _GameWebviewToggleButtonWidget();
}

class _GameWebviewToggleButtonWidget
    extends State<GameWebviewToggleButtonWidget> {
  final systemConfig = GameSystemConfig();
  final gameConfigController = Get.put(GameConfigController());

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return PointerInterceptor(
      child: RotatedBox(
        quarterTurns: !GetPlatform.isWeb
            ? 0
            : widget.direction == gameWebviewDirection['vertical']
                ? (orientation == Orientation.portrait ? 0 : 1)
                : (orientation == Orientation.portrait ? 1 : 0),
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
                  showConfirmDialog(
                    context: context,
                    title: '退出遊戲',
                    content: '你真的要退出遊戲嗎？',
                    rotate: !GetPlatform.isWeb
                        ? false
                        : widget.direction == gameWebviewDirection['vertical']
                            ? (orientation == Orientation.portrait
                                ? false
                                : true)
                            : (orientation == Orientation.portrait
                                ? true
                                : false),
                    onConfirm: () {
                      MyRouteDelegate.of(context).popRoute();
                      Get.find<GameStartupController>()
                          .goBackToAppHome(context);
                    },
                    onCancel: () {
                      Navigator.pop(context);
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
                  launchUrl(Uri.parse(
                      '${systemConfig.apiHost}/public/domains/domain/customer-services'));
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
