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
        // if (image.url!.isNotEmpty) {
        //   // Get.find<BannerController>().recordBannerClick(int.parse(image.photoId));
        //   if (image.url!.startsWith('http://') ||
        //       image.url!.startsWith('https://')) {
        //     // ignore: deprecated_member_use
        //     launch(image.url.toString(), webOnlyWindowName: '_blank');
        //   } else {
        //     MyRouteDelegate.of(context).push(image.url.toString());
        //   }
        // }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6.0),
        child: Image.network(
          image.photoUrl ?? '',
          width: Get.width,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
