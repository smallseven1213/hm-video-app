import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/banner_controller.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:url_launcher/url_launcher.dart';

class BannerLink extends StatelessWidget {
  final int id;
  final String url;
  final Widget child;

  const BannerLink({
    super.key,
    required this.id,
    required this.url,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.find<BannerController>().recordBannerClick(id);
        if (url.startsWith('http://') || url.startsWith('https://')) {
          launch(url, webOnlyWindowName: '_blank');
        } else {
          MyRouteDelegate.of(context).push(url);
        }
      },
      child: child,
    );
  }
}
