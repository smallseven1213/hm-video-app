import 'package:flutter/material.dart';
import 'package:shared/modules/user/user_info_consumer.dart';
import 'package:shared/modules/user/user_info_v2_consumer.dart';

import 'auth_buttons.dart';
import 'user_info.dart';

class UserArea extends StatelessWidget {
  const UserArea({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: UserInfoV2Consumer(
        child: (info, isVIP, isGuest) {
          if (isGuest == false) {
            return UserInfo(info: info);
          } else {
            return const AuthButtons();
          }
        },
      ),
    );
  }
}
