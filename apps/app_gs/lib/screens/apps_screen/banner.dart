import 'package:app_gs/widgets/carousel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/banner_controller.dart';
import 'package:shared/models/banner_photo.dart';
import 'package:shared/models/index.dart';

final logger = Logger();

class BannerWidget extends StatefulWidget {
  const BannerWidget({
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
      var banners = bannerController.banners[BannerPosition.discoverCarousel]
          as List<BannerPhoto>?;
      if (banners == null || banners.isEmpty) {
        return Container();
      } else {
        List<BannerImage> images = banners
            .map(
              (e) => BannerImage.fromJson({
                'id': e.id ?? 0,
                'url': e.url ?? '',
                'photoSid': e.photoSid,
                'isAutoClose': false,
              }),
            )
            .toList();
        print(banners);
        return Carousel(
          images: images,
          ratio: 359 / 170,
        );
      }
    });
  }
}
