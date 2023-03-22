import 'package:flutter/material.dart';
import 'package:shared/models/channel_info.dart';
import 'package:shared/widgets/banner_link.dart';
import 'package:shared/widgets/sid_image.dart';

class AdBanner extends StatelessWidget {
  final BannerImage image;
  const AdBanner({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BannerLink(
        id: image.id ?? 0,
        url: image.url ?? '',
        child: image.photoSid != null && image.photoSid!.isNotEmpty
            ? SidImage(
                width: double.infinity,
                height: double.infinity,
                sid: image.photoSid!,
                fit: BoxFit.cover,
              )
            : Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.grey,
              ));
  }
}
