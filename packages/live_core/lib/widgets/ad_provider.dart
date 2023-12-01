import 'package:flutter/material.dart';
import 'package:live_core/controllers/ad_controller.dart';
import 'package:get/get.dart';

import '../models/ad.dart';

class AdProvider extends StatefulWidget {
  final Widget Function(List<Ad> ads) child;
  const AdProvider({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  AdPageState createState() => AdPageState();
}

class AdPageState extends State<AdProvider> {
  final AdController _adController = Get.put(AdController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => widget.child(_adController.ads));
  }
}
