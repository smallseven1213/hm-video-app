import 'package:app_gs/widgets/carousel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/banner_controller.dart';
import 'package:shared/models/banner_image.dart';
import 'package:shared/models/banner_photo.dart';
import 'package:shared/models/index.dart';

class UserSreenBanner extends StatefulWidget {
  const UserSreenBanner({Key? key}) : super(key: key);

  @override
  _UserSreenBannerState createState() => _UserSreenBannerState();
}

class _UserSreenBannerState extends State<UserSreenBanner> {
  final BannerController bannerController = Get.find<BannerController>();

  @override
  void initState() {
    super.initState();
    bannerController.fetchBanner(BannerPosition.userCenter);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var banners = bannerController.banners[BannerPosition.userCenter]
          as List<BannerPhoto>?;
      if (banners == null || banners.isEmpty) {
        return const SizedBox.shrink();
      }

      return banners.isNotEmpty == true
          ? AspectRatio(
              aspectRatio: 359 / 75,
              child: Carousel(
                images: banners,
                ratio: 359 / 75,
              ),
            )
          : const SizedBox.shrink();
    });
  }
}
