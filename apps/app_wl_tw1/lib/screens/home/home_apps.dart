import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/bottom_navigator_controller.dart';

import '../../widgets/custom_app_bar.dart';
import '../apps_screen/index.dart';

class HomeAppsScreen extends StatelessWidget {
  const HomeAppsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bottomNavigatorController = Get.find<BottomNavigatorController>();
    return PopScope(
      canPop: false, // HC: 煩死，勿動!!
      child: Scaffold(
        appBar: CustomAppBar(
          leadingWidget: Container(),
          titleWidget: Obx(
            () => Text(
              bottomNavigatorController.activeTitle.value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ),
        ),
        body: const AppsScreen(),
      ),
    );
  }
}
