import 'package:app_wl_cn1/widgets/carousel.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/index.dart';
import 'package:shared/modules/banner/banner_consumer..dart';

class UserScreenBanner extends StatefulWidget {
  const UserScreenBanner({Key? key}) : super(key: key);

  @override
  UserScreenBannerState createState() => UserScreenBannerState();
}

class UserScreenBannerState extends State<UserScreenBanner> {
  @override
  Widget build(BuildContext context) {
    return BannerConsumer(
        position: BannerPosition.userCenter,
        child: (banners) => AspectRatio(
              aspectRatio: 359 / 75,
              child: Carousel(
                images: banners,
                ratio: 359 / 75,
              ),
            ));
  }
}
