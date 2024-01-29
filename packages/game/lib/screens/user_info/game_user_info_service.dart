import 'package:flutter/material.dart';
import 'package:game/controllers/game_banner_controller.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:game/services/game_system_config.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../localization/game_localization_delegate.dart';

class UserInfoService extends StatefulWidget {
  const UserInfoService({Key? key}) : super(key: key);

  @override
  State<UserInfoService> createState() => _UserInfoService();
}

class _UserInfoService extends State<UserInfoService> {
  final systemConfig = GameSystemConfig();
  final gameBannerController = Get.put(GameBannerController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final GameLocalizations localizations = GameLocalizations.of(context)!;

    return SizedBox(
      width: 60,
      height: 60,
      child: InkWell(
        onTap: () {
          launch(gameBannerController.customerServiceUrl.value);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              "packages/game/assets/images/game_lobby/service.webp",
              width: 28,
              height: 28,
            ),
            Text(
              localizations.translate('customer_service'),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: gameLobbyPrimaryTextColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
