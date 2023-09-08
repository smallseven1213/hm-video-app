import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/user_controller.dart';

class UserInfoReloadButton extends StatelessWidget {
  final Widget child;
  final userController = Get.find<UserController>();

  UserInfoReloadButton({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          userController.fetchUserInfo();
        },
        child: child);
  }
}
