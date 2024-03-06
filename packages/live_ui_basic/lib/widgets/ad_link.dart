import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_core/controllers/ad_controller.dart';
import 'package:shared/utils/handle_url.dart';

class AdLink extends StatelessWidget {
  final int id;
  final String url;
  final Widget child;

  const AdLink({
    super.key,
    required this.id,
    required this.url,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        try {
          Get.find<AdController>().recordAdClick(id);
          if (url.isEmpty) return;

          final Uri parsedUrl = Uri.parse(url);

          if (url.startsWith('http://') || url.startsWith('https://')) {
            handleHttpUrl(url);
          } else if (parsedUrl.queryParameters.containsKey('depositType')) {
            handleGameDepositType(context, url);
          } else if (parsedUrl.queryParameters
              .containsKey('defaultScreenKey')) {
            handleDefaultScreenKey(context, url);
          } else {
            handlePathWithId(context, url);
          }
        } catch (e) {
          rethrow;
        }
      },
      child: child,
    );
  }
}
