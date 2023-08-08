import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/user_controller.dart';

class UserDataGettingStatusConsumer extends StatelessWidget {
  final Widget Function(bool isLoading) child;
  const UserDataGettingStatusConsumer({Key? key, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();
    // ignore: invalid_use_of_protected_member
    return Obx(() => child(userController.isLoading.value));
  }
}
