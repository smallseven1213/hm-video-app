import 'package:flutter/material.dart';
import 'package:game/controllers/game_banner_controller.dart';
import 'package:get/get.dart';

class GameBannerAndMarqueeConsumer extends StatelessWidget {
  final Widget Function(List banner, List marquee, String customerServiceUrl)
      child;

  GameBannerAndMarqueeConsumer({
    Key? key,
    required this.child,
  }) : super(key: key);

  final GameBannerController gameBannerController =
      Get.find<GameBannerController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => child(
        gameBannerController.gameBanner.value,
        gameBannerController.gameMarquee.value,
        gameBannerController.customerServiceUrl.value,
      ),
    );
  }
}
