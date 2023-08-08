import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/user_controller.dart';

import '../../models/user.dart';

class UserInfoConsumer extends StatelessWidget {
  final Widget Function(User info, bool isVIP, bool isGuest) child;
  const UserInfoConsumer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();
    var isVIP = userController.info.value.roles.contains('vip');
    var isGuest = userController.info.value.roles.contains('guest');
    // ignore: invalid_use_of_protected_member
    return Obx(() => child(userController.info.value, isVIP, isGuest));
  }
}
