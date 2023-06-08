import 'package:flutter/material.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:game/services/game_system_config.dart';
import 'package:url_launcher/url_launcher.dart';

class UserInfoService extends StatefulWidget {
  const UserInfoService({Key? key}) : super(key: key);
  // final String points;
  // final VoidCallback onTap;

  @override
  State<UserInfoService> createState() => _UserInfoService();
}

class _UserInfoService extends State<UserInfoService> {
  final systemConfig = GameSystemConfig();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 30,
      height: 60,
      child: InkWell(
        onTap: () {
          launchUrl(Uri.parse(
              '${systemConfig.apiHost}/public/domains/domain/customer-services'));
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
              '客服',
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
