import 'package:app_tt/localization/i18n.dart';
import 'package:app_tt/screens/layout_user_screen/user_card/open_drawer_button.dart';
import 'package:app_tt/screens/layout_user_screen/user_card/search_button.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/user.dart';

import '../../widgets/actor_avatar.dart';
import '../../widgets/user_empty_avatar.dart';

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

    return Container(
      padding: EdgeInsets.only(top: systemTopBarHeight),
      height: 300,
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
            top: 50,
            right: 16,
            child: Row(
              children: [
                SearchButton(),
                SizedBox(width: 10),
                OpenDrawerButton()
              ],
            ),
          ),
          // 大頭照
          Positioned(
            top: 99,
            left: 16,
            child: info.avatar == null
                ? const UserEmptyAvatar()
                : ActorAvatar(
                    photoSid: info.avatar,
                    width: 99,
                    height: 99,
                  ),
          ),
          // 名字
          Positioned(
            top: 123,
            left: 123,
            child: Text(
              info.nickname ?? '',
              style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 21,
                  color: Colors.white),
            ),
          ),
          // 用戶ID
          Positioned(
            top: 155,
            left: 123,
            child: Text('${I18n.memberId}: ${info.uid}',
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                  // color is white, and opacity is 0.5
                  color: Color(0x80ffffff),
                )),
          ),
        ],
      ),
    );
  }
}
