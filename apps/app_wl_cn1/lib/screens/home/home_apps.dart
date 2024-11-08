import 'package:app_wl_cn1/screens/home/fab_banner.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/bottom_navigator_controller.dart';

import 'package:shared/utils/handle_url.dart';

import '../../widgets/custom_app_bar.dart';
import '../apps_screen/index.dart';

class HomeAppsScreen extends StatefulWidget {
  const HomeAppsScreen({Key? key}) : super(key: key);

  @override
  HomeAppsScreenState createState() => HomeAppsScreenState();
}

class HomeAppsScreenState extends State<HomeAppsScreen> {
  final BottomNavigatorController bottomNavigatorController =
      Get.find<BottomNavigatorController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    bottomNavigatorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // HC: 煩死，勿動!!
      child: Stack(
        children: [
          Scaffold(
            appBar: CustomAppBar(
              leadingWidth: 0,
              leadingWidget: Container(),
              titleWidget: Text(
                bottomNavigatorController.activeTitle.value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ),
            body: const AppsScreen(),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: FabBanner(),
          ),
        ],
      ),
    );
  }
}
