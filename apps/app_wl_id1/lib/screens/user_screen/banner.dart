import 'package:app_wl_id1/widgets/carousel.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/index.dart';
import 'package:shared/modules/banner/banner_consumer.dart';

class UserSreenBanner extends StatefulWidget {
  const UserSreenBanner({Key? key}) : super(key: key);

  @override
  UserSreenBannerState createState() => UserSreenBannerState();
}

class UserSreenBannerState extends State<UserSreenBanner> {
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
