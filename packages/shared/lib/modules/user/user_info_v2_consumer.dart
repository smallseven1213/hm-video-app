import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/user_controller.dart';

import '../../models/user_v2.dart';

class UserInfoV2Consumer extends StatelessWidget {
  final Widget Function(
    UserV2 info,
    bool isVIP,
    bool isGuest,
    bool isLoading,
    bool isInfoV2Init,
  ) child;
  const UserInfoV2Consumer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();

    // ignore: invalid_use_of_protected_member
    return Obx(() {
      var vipExpiredAt = userController.infoV2.value.vipExpiredAt;
      var isVIP = vipExpiredAt != null && vipExpiredAt.isAfter(DateTime.now());
      var isGuest = userController.infoV2.value.roles.contains('guest');
      var isLoading = userController.isInfoV2Loading.value;
      var isInfoV2Init = userController.isInfoV2Init.value;

      return child(
        userController.infoV2.value,
        isVIP,
        isGuest,
        isLoading,
        isInfoV2Init,
      );
    });
  }
}
