import 'package:app_gp/widgets/carousel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/banner_controller.dart';
import 'package:shared/models/banner.dart';
import 'package:shared/models/index.dart';

final logger = Logger();

class BannerWidget extends StatefulWidget {
  BannerWidget({
    Key? key,
  }) : super(key: key);

  @override
  _BannerWidgetState createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  BannerController bannerController = Get.find<BannerController>();

  @override
  void initState() {
    super.initState();
    bannerController.fetchBanner(BannerPosition.discoverCarousel);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var banners = bannerController
          .banners[BannerPosition.discoverCarousel.index] as List<BannerPhoto>?;
      if (banners == null || banners.isEmpty) {
        return Container();
      } else {
        List<BannerImage> images = banners
            .map((e) => BannerImage(
                  id: e.id,
                  photoSid: e.photoSid,
                  url: e.url,
                  isAutoClose: e.isAutoClose,
                ))
            .toList();

        return Carousel(images: images);
      }
    });
  }
}
