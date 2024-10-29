import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../controllers/system_config_controller.dart';
import 'user_info_v2_consumer.dart';

final logger = Logger();

class WatchPermissionProvider extends StatefulWidget {
  final Widget Function(bool canWatch) child;
  final void Function() showConfirmDialog;

  const WatchPermissionProvider({
    Key? key,
    required this.child,
    required this.showConfirmDialog,
  }) : super(key: key);

  @override
  WatchPermissionProviderState createState() => WatchPermissionProviderState();
}

class WatchPermissionProviderState extends State<WatchPermissionProvider> {
  final SystemConfigController systemConfigController =
      Get.find<SystemConfigController>();
  bool _dialogShown = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _showLoginDialog(BuildContext context) {
    if (!_dialogShown) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.showConfirmDialog();
        setState(() {
          _dialogShown = true;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return UserInfoV2Consumer(
        child: (info, isVIP, isGuest, isLoading, isInfoV2Init) {
      if (isLoading) {
        return const SizedBox.shrink();
      } else if (isGuest && systemConfigController.loginToWatch.value) {
        _showLoginDialog(context);
      }

      bool canWatch =
          systemConfigController.loginToWatch.value ? !isGuest : true;
      return widget.child(canWatch);
    });
  }
}
