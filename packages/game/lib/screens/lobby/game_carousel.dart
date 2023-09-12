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
  GameCarouselState createState() => GameCarouselState();
}

class GameCarouselState extends State<GameCarousel> {
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
        try {
          List<GameBannerImage> images = widget.data
              .map(
                (e) => GameBannerImage.fromJson({
                  'photoId': e['photoId'] ?? '',
                  'photoUrl':
                      'https://images.unsplash.com/photo-1600716051809-e997e11a5d52?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2050&q=80',
                  'url': e['url'] ?? '',
                }),
              )
              .toList();
          return Carousel(
            images: images,
            ratio: 2.47,
          );
        } catch (e) {
          return const Text('Error', style: TextStyle(color: Colors.red));
        }
      }
    });
  }
}
