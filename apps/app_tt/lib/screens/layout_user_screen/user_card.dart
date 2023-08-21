import 'package:flutter/material.dart';
import 'package:shared/models/user.dart';

import '../../widgets/actor_avatar.dart';
import 'user_card_menu_button.dart';

class UserCard extends StatelessWidget {
  final User info;

  const UserCard({
    super.key,
    required this.info,
  });

  @override
  Widget build(BuildContext context) {
    // final screenWidth = MediaQuery.of(context).size.width;
    final systemTopBarHeight = MediaQuery.of(context).padding.top;

    return Padding(
      padding: EdgeInsets.only(top: systemTopBarHeight),
      child: Container(
        color: const Color(0xFF001a40),
        height: 240,
        child: Stack(
          children: [
            // const Positioned.fill(
            //   child: Image(
            //     image: AssetImage('assets/images/supplier_card_bg.webp'),
            //     fit: BoxFit.fill,
            //   ),
            // ),
            // DrawerButton
            const Positioned(
              top: 10,
              right: 16,
              child: UserCardMenuButton(),
            ),
            // 大頭照
            Positioned(
              top: 59,
              child: ActorAvatar(
                photoSid: info.avatar,
                width: 99,
                height: 99,
              ),
            ),
            // 名字
            Positioned(
              top: 83,
              left: 100,
              child: Text(
                info.nickname ?? '',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 21,
                    color: Colors.white),
              ),
            ),
            // 用戶ID
            Positioned(
              top: 110,
              left: 100,
              child: Text(
                '用戶ID: ${info.id}',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
