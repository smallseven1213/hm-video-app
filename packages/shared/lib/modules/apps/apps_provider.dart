import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/apps_controller.dart';
import '../../models/ad.dart';

class AppsProvider extends StatefulWidget {
  final Function(
      {required List<Ads> popularAds,
      required List<Ads> hotAds,
      required bool isLoading}) child;
  const AppsProvider({Key? key, required this.child}) : super(key: key);

  @override
  AppsProviderState createState() => AppsProviderState();
}

class AppsProviderState extends State<AppsProvider> {
  final appsController = Get.find<AppsController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => widget.child(
          // ignore: invalid_use_of_protected_member
          popularAds: appsController.popular.value,
          // ignore: invalid_use_of_protected_member
          hotAds: appsController.hot.value,
          isLoading: appsController.isLoading.value,
        ));
  }
}
