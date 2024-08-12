// ignore: unnecessary_import
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:game/controllers/game_banner_controller.dart';
import 'package:game/services/game_system_config.dart';
import 'package:game/utils/show_confirm_dialog.dart';
import 'package:game/widgets/game_startup.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:shared/controllers/game_platform_config_controller.dart';
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
  final gameConfigController = Get.find<GamePlatformConfigController>();
  final gameBannerController = Get.put(GameBannerController());

  @override
  Widget build(BuildContext context) {
    final GameLocalizations localizations = GameLocalizations.of(context)!;

    return PointerInterceptor(
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
            SizedBox(
              width: 58,
              child: InkWell(
                onTap: () {
                  showConfirmDialog(
                    context: context,
                    title: localizations.translate('quit_the_game'),
                    content: localizations
                        .translate('do_you_really_want_to_quit_the_game'),
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
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontFeatures: [FontFeature.proportionalFigures()],
                      ),
                    ), // <-- Text
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 58,
              child: InkWell(
                onTap: () {
                  launchUrl(
                      Uri.parse(gameBannerController.customerServiceUrl.value));
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
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ), // <-- Text
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 58,
              child: InkWell(
                onTap: () {
                  logger.i('充值');
                  MyRouteDelegate.of(context)
                      .push(gameConfigController.depositRoute.value);
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
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ), // <-- Text
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 58,
              child: InkWell(
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
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ), // <-- Text
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
