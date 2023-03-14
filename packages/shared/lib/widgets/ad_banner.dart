import 'package:flutter/material.dart';
import 'package:shared/models/channel_info.dart';
import 'package:shared/widgets/banner_link.dart';
import 'package:shared/widgets/sid_image.dart';

class AdBanner extends StatelessWidget {
  final BannerImage image;
  const AdBanner({
    super.key,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return BannerLink(
      image: image,
      child: SidImage(
        width: double.infinity,
        height: double.infinity,
        sid: image.photoSid.toString(),
        fit: BoxFit.cover,
      ),
    );
  }
}
