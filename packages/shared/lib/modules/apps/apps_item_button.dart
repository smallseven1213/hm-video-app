import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../apis/ads_api.dart';

class AppsItemButton extends StatelessWidget {
  final dynamic id;
  final String url;
  final Widget child;
  const AppsItemButton(
      {Key? key, required this.id, required this.child, required this.url})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        int convertedId;
        if (id is String) {
          convertedId = int.parse(id);
        } else if (id is int) {
          convertedId = id;
        } else {
          throw 'Invalid data type for id';
        }
        AdsApi().addBannerClickRecord(convertedId);

        launchUrl(Uri.parse(url));
      },
      child: child,
    );
  }
}
