import 'package:flutter/material.dart';
import 'package:shared/models/index.dart';
import 'package:shared/modules/banner/banner_consumer.dart';
import '../../widgets/carousel.dart';

class VideoScreenBanner extends StatefulWidget {
  const VideoScreenBanner({Key? key}) : super(key: key);

  @override
  VideoScreenBannerState createState() => VideoScreenBannerState();
}

class VideoScreenBannerState extends State<VideoScreenBanner> {
  @override
  Widget build(BuildContext context) {
    return BannerConsumer(
        position: BannerPosition.playBottomCarousel,
        child: (banners) {
          if (banners.isEmpty) {
            return const SizedBox.shrink();
          }
          return banners.isNotEmpty == true
              ? AspectRatio(
                  aspectRatio: 380 / 104,
                  child: Carousel(
                    images: banners,
                    ratio: 380 / 104,
                    scrollPhysics: const NeverScrollableScrollPhysics(),
                  ),
                )
              : const SizedBox.shrink();
        });
  }
}
