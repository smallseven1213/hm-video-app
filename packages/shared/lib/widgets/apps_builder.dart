import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/apps_controller.dart';
import '../models/ad.dart';

class AppsBuilder extends StatefulWidget {
  final Function(
      {required List<Ads> popularAds,
      required List<Ads> hotAds,
      required bool isLoading}) child;
  const AppsBuilder({Key? key, required this.child}) : super(key: key);

  @override
  AppsBuilderState createState() => AppsBuilderState();
}

class AppsBuilderState extends State<AppsBuilder> {
  final appsController = Get.find<AppsController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => widget.child(
          popularAds: appsController.popular.value,
          hotAds: appsController.hot.value,
          isLoading: appsController.isLoading.value,
        ));
  }
}
