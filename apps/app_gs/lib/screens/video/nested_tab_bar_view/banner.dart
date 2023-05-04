import 'package:app_gs/widgets/carousel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/banner_controller.dart';
import 'package:shared/models/banner_photo.dart';
import 'package:shared/models/index.dart';

class VideoScreenBanner extends StatefulWidget {
  const VideoScreenBanner({Key? key}) : super(key: key);

  @override
  _VideoScreenBannerState createState() => _VideoScreenBannerState();
}

class _VideoScreenBannerState extends State<VideoScreenBanner> {
  final BannerController bannerController = Get.find<BannerController>();

  @override
  void initState() {
    super.initState();
    bannerController.fetchBanner(BannerPosition.playBottomCarousel);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var banners = bannerController.banners[BannerPosition.playBottomCarousel]
          as List<BannerPhoto>?;
      if (banners == null || banners.isEmpty) {
        return const SizedBox.shrink();
      }

      List<BannerImage> images = banners
          .map(
            (e) => BannerImage.fromJson({
              'id': e.id,
              'url': e.url ?? '',
              'photoSid': e.photoSid,
              'isAutoClose': false,
            }),
          )
          .toList();
      return images.isNotEmpty == true
          ? AspectRatio(
              aspectRatio: 374 / 104,
              child: Carousel(
                images: images,
                ratio: 374 / 104,
              ),
            )
          : const SizedBox.shrink();
    });
  }
}
