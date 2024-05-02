import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/user_controller.dart';

import '../../models/user_v2.dart';

class UserInfoV2Consumer extends StatelessWidget {
  final Widget Function(UserV2 info, bool isVIP, bool isGuest) child;
  const UserInfoV2Consumer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();

    // ignore: invalid_use_of_protected_member
    return Obx(() {
      var isVIP = userController.infoV2.value.roles.contains('vip');
      var isGuest = userController.infoV2.value.roles.contains('guest');

      return child(userController.infoV2.value, isVIP, isGuest);
    });
  }
}
