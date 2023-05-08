import 'package:flutter/material.dart';
import 'package:game/models/game_banner_image.dart';
import 'package:game/widgets/carousel.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class GameCarousel extends StatefulWidget {
  final List data;

  const GameCarousel({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  _GameCarouselState createState() => _GameCarouselState();
}

class _GameCarouselState extends State<GameCarousel> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var banners = widget.data;
      if (banners.isEmpty) {
        return const SizedBox();
      } else {
        List<GameBannerImage> images = banners
            .map(
              (e) => GameBannerImage.fromJson({
                'photoId': e['photoId'] ?? '',
                'photoUrl': e['photoUrl'] ?? '',
                'url': e['url'] ?? '',
              }),
            )
            .toList();
        return Carousel(
          images: images,
          ratio: 359 / 170,
        );
      }
    });
  }
}
