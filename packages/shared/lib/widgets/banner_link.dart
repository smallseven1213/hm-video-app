import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/banner_controller.dart';
import 'package:shared/utils/handle_url.dart';

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

        final Uri parsedUrl = Uri.parse(url);

        if (url.startsWith('http://') || url.startsWith('https://')) {
          handleHttpUrl(url);
        } else if (parsedUrl.queryParameters.containsKey('depositType')) {
          handleGameDepositType(context, url);
        } else if (parsedUrl.queryParameters.containsKey('defaultScreenKey')) {
          handleDefaultScreenKey(context, url);
        } else {
          handlePathWithId(context, url);
        }
      },
      child: child,
    );
  }
}
