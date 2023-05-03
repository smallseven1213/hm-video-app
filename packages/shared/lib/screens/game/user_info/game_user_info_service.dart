import 'package:flutter/material.dart';
import 'package:shared/screens/game/game_theme_config.dart';

class UserInfoService extends StatefulWidget {
  const UserInfoService({Key? key}) : super(key: key);
  // final String points;
  // final VoidCallback onTap;

  @override
  State<UserInfoService> createState() => _UserInfoService();
}

class _UserInfoService extends State<UserInfoService> {
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
          // launch(
          //     '${AppController.cc.endpoint.getApi()}/public/domains/domain/customer-services');
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              "assets/img/game_lobby/service.webp",
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
