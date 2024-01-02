import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:live_core/models/ad.dart';
import 'package:live_core/widgets/ad_provider.dart';
import 'package:live_core/widgets/live_image.dart';

import '../../widgets/ad_link.dart';
import '../../widgets/network_image.dart';

class BannersWidget extends StatelessWidget {
  static const double aspectRatioValue = 341 / 143;
  final CarouselController _carouselController = CarouselController();

  BannersWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatioValue,
      child: AdProvider(child: (List<Ad> ads) {
        if (ads.isEmpty) {
          return const SizedBox.shrink();
        }
        return CarouselSlider.builder(
          carouselController: _carouselController,
          itemCount: ads.length,
          options: CarouselOptions(
            aspectRatio: aspectRatioValue,
            enlargeCenterPage: true,
            viewportFraction: 1,
          ),
          itemBuilder:
              (BuildContext context, int itemIndex, int pageViewIndex) {
            var ad = ads[itemIndex];
            return AdLink(
              url: ad.link,
              id: ad.id,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(30),
                  ),
                ),
                child: Center(child: LiveImage(base64Url: ad.image)),
              ),
            );
          },
        );
      }),
    );
  }
}
