import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:game/models/game_banner_image.dart';

class BannerItem extends StatelessWidget {
  final GameBannerImage image;
  const BannerItem({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (image.url!.isNotEmpty) {
          // Get.find<BannerController>().recordBannerClick(int.parse(image.photoId));
          if (image.url!.startsWith('http://') ||
              image.url!.startsWith('https://')) {
            // ignore: deprecated_member_use
            launch(image.url.toString(), webOnlyWindowName: '_blank');
          } else {
            MyRouteDelegate.of(context).push(image.url.toString());
          }
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6.0),
        child: Image.network(
          'https://images.unsplash.com/photo-1600716051809-e997e11a5d52?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2050&q=80',
          width: Get.width,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
