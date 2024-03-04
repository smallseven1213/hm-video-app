import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/game_platform_config_controller.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';

class GameEnvelopeButton extends StatefulWidget {
  final bool hasDownload;

  const GameEnvelopeButton({
    Key? key,
    required this.hasDownload,
  }) : super(key: key);

  @override
  State<GameEnvelopeButton> createState() => GameEnvelopeButtonState();
}

class GameEnvelopeButtonState extends State<GameEnvelopeButton> {
  GamePlatformConfigController gameConfigController =
      Get.find<GamePlatformConfigController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 65,
      height: 65,
      decoration: const BoxDecoration(
        color: Colors.transparent,
        image: DecorationImage(
          image: AssetImage(
              'packages/game/assets/images/game_lobby/red-envelope.webp'),
        ),
      ),
      child: Wrap(
        direction: Axis.vertical,
        children: [
          InkWell(
            onTap: () => gameConfigController.setEnvelopeStatus(false),
            child: const SizedBox(
              width: 65,
              height: 15,
            ),
          ),
          InkWell(
            onTap: () {
              MyRouteDelegate.of(context).push(AppRoutes.register);
            },
            child: const SizedBox(
              width: 65,
              height: 50,
            ),
          ),
        ],
      ),
    );
  }
}
