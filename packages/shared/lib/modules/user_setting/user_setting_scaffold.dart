import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../controllers/user_navigator_controller.dart';

class UserSettingScaffold extends StatefulWidget {
  final Function() onAccountProtectionShownH5;
  final Function() onAccountProtectionShown;
  final Widget child;
  final bool preventBackNavigation;
  const UserSettingScaffold({
    Key? key,
    required this.onAccountProtectionShown,
    required this.onAccountProtectionShownH5,
    required this.child,
    this.preventBackNavigation = true,
  }) : super(key: key);

  @override
  UserSettingScaffoldState createState() => UserSettingScaffoldState();
}

class UserSettingScaffoldState extends State<UserSettingScaffold> {
  final storage = GetStorage();
  final userNavigatorController = Get.find<UserNavigatorController>();

  checkFirstSeen() {
    final accountProtectionShown = storage.read('account-protection-shown');
    if (accountProtectionShown == null) {
      storage.write('account-protection-shown', true);
      if (kIsWeb) {
        widget.onAccountProtectionShownH5();
      } else {
        widget.onAccountProtectionShown();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkFirstSeen();
    });
  }

  void setAccountProtectionShownToTrue() {
    storage.write('account-protection-shown', true);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.preventBackNavigation) {
      return PopScope(
        canPop: false,
        child: widget.child,
      );
    } else {
      return widget.child;
    }
  }
}
