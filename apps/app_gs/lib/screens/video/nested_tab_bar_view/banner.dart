import 'package:app_gs/widgets/carousel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/banner_controller.dart';
import 'package:shared/models/index.dart';

class VideoScreenBanner extends StatefulWidget {
  const VideoScreenBanner({Key? key}) : super(key: key);

  @override
  VideoScreenBannerState createState() => VideoScreenBannerState();
}

class VideoScreenBannerState extends State<VideoScreenBanner> {
  final BannerController bannerController = Get.find<BannerController>();

  @override
  void initState() {
    super.initState();
    bannerController.fetchBanner(BannerPosition.playBottomCarousel);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var banners = bannerController.banners[BannerPosition.playBottomCarousel];
      if (banners == null || banners.isEmpty) {
        return const SizedBox.shrink();
      }
      return banners.isNotEmpty == true
          ? AspectRatio(
              aspectRatio: 374 / 104,
              child: Carousel(
                images: banners,
                ratio: 374 / 104,
                scrollPhysics: const NeverScrollableScrollPhysics(),
              ),
            )
          : const SizedBox.shrink();
    });
  }
}
