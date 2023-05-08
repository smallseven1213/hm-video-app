import 'package:flutter/material.dart';
import 'package:shared/models/banner_photo.dart';
import 'package:shared/widgets/ad_banner.dart';

class ChannelAreaBanner extends StatelessWidget {
  final BannerPhoto image;
  const ChannelAreaBanner({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 374 / 101,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        clipBehavior: Clip.antiAlias,
        child: AdBanner(image: image),
      ),
    );
  }
}
