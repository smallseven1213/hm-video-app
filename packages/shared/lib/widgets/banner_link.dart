import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/banner_controller.dart';
import 'package:shared/models/channel_info.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:url_launcher/url_launcher.dart';

class BannerLink extends StatelessWidget {
  final BannerImage image;
  final Widget child;

  const BannerLink({
    super.key,
    required this.image,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.find<BannerController>().recordBannerClick(image.id ?? 0);
        if (image.url!.startsWith('http://') ||
            image.url!.startsWith('https://')) {
          launch(image.url ?? '', webOnlyWindowName: '_blank');
        } else {
          MyRouteDelegate.of(context).push(image.url ?? '');
        }
      },
      child: child,
    );
  }
}
