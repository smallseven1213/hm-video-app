import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/banner_controller.dart';
import '../../models/banner.dart';
import '../../models/banner_photo.dart';

class BannerConsumer extends StatefulWidget {
  final BannerPosition position;
  final Widget Function(List<BannerPhoto>) child;
  const BannerConsumer({Key? key, required this.position, required this.child})
      : super(key: key);

  @override
  BannerConsumerState createState() => BannerConsumerState();
}

class BannerConsumerState extends State<BannerConsumer> {
  final BannerController bannerController = Get.find<BannerController>();

  @override
  void initState() {
    super.initState();
    bannerController.fetchBanner(widget.position);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var banners = bannerController.banners[widget.position];
      if (banners == null || banners.isEmpty) {
        return const SizedBox.shrink();
      }

      return widget.child(banners);
    });
  }
}
