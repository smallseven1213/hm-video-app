// UserSettingQuickLinkConsumer,has props child, Getx find UserNavigatorController, and return quickLink of UserNavigatorController's value to child

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/user_navigator_controller.dart';
import '../../models/navigation.dart';

class UserSettingQuickLinkConsumer extends StatelessWidget {
  final Widget Function(List<Navigation> quickLinks) child;
  const UserSettingQuickLinkConsumer({Key? key, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userNavigatorController = Get.find<UserNavigatorController>();
    // ignore: invalid_use_of_protected_member
    return Obx(() => child(userNavigatorController.quickLink.value));
  }
}
