import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:game/controllers/game_banner_controller.dart';
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

import '../../localization/game_localization_delegate.dart';

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
  final gameBannerController = Get.put(GameBannerController());

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final GameLocalizations localizations = GameLocalizations.of(context)!;

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
                    title: localizations.translate('quit_the_game'),
                    content: localizations
                        .translate('do_you_really_want_to_quit_the_game'),
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
                    Text(
                      localizations.translate('return_to_the_lobby'),
                      style: const TextStyle(
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
                  launch(gameBannerController.customerServiceUrl.value);
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
                    Text(
                      localizations.translate('customer_service'),
                      style: const TextStyle(
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
                  MyRouteDelegate.of(context).push(
                    gameConfigController.switchPaymentPage.value ==
                            switchPaymentPageType['list']
                        ? GameAppRoutes.depositList
                        : GameAppRoutes.depositPolling,
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
                    Text(
                      localizations.translate('recharge'),
                      style: const TextStyle(
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
                    Text(
                      localizations.translate('close'),
                      style: const TextStyle(
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
