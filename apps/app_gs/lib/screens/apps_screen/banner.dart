import 'package:app_gs/widgets/carousel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/banner_controller.dart';
import 'package:shared/models/index.dart';

final logger = Logger();

class BannerWidget extends StatefulWidget {
  const BannerWidget({
    Key? key,
  }) : super(key: key);

  @override
  BannerWidgetState createState() => BannerWidgetState();
}

class BannerWidgetState extends State<BannerWidget> {
  BannerController bannerController = Get.find<BannerController>();

  @override
  void initState() {
    super.initState();
    bannerController.fetchBanner(BannerPosition.discoverCarousel);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var banners = bannerController.banners[BannerPosition.discoverCarousel];
      if (banners == null || banners.isEmpty) {
        return Container();
      } else {
        return Carousel(
          images: banners,
          ratio: 359 / 170,
        );
      }
    });
  }
}
