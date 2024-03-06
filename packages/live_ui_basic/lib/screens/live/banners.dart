import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:live_core/models/ad.dart';
import 'package:live_core/widgets/ad_provider.dart';
import 'package:live_core/widgets/live_image.dart';

import '../../widgets/ad_link.dart';
import '../../widgets/network_image.dart';

class BannersWidget extends StatefulWidget {
  static const double aspectRatioValue = 341 / 143;

  const BannersWidget({Key? key}) : super(key: key);

  @override
  _BannersWidgetState createState() => _BannersWidgetState();
}

class _BannersWidgetState extends State<BannersWidget> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: BannersWidget.aspectRatioValue,
      child: AdProvider(child: (List<Ad> ads) {
        if (ads.isEmpty) {
          return const SizedBox.shrink();
        }
        return BannersView(
          ads: ads,
        );
      }),
    );
  }
}

class BannersView extends StatefulWidget {
  final List<Ad> ads;

  const BannersView({Key? key, required this.ads}) : super(key: key);

  @override
  BannersViewState createState() => BannersViewState();
}

class BannersViewState extends State<BannersView> {
  int _current = 0;
  List<Widget> bannerSliders = [];
  final CarouselController _carouselController = CarouselController();

  @override
  void initState() {
    super.initState();
    bannerSliders = widget.ads.map((ad) {
      return AdLink(
        url: ad.link,
        id: ad.id,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: LiveImage(
            base64Url: ad.image,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CarouselSlider(
          items: bannerSliders,
          carouselController: _carouselController,
          options: CarouselOptions(
              aspectRatio: BannersWidget.aspectRatioValue,
              enlargeCenterPage: true,
              autoPlay: true,
              viewportFraction: 1,
              autoPlayInterval: const Duration(seconds: 5),
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }),
        ),
        Positioned(
          right: 10,
          bottom: 5,
          child: Row(
            children: List.generate(widget.ads.length, (index) {
              return Container(
                width: 8.0,
                height: 8.0,
                margin:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _current == index ? Colors.white : Colors.grey,
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

class BannerDotsIndicator extends StatefulWidget {
  final int current;
  final int length;

  const BannerDotsIndicator({
    Key? key,
    required this.current,
    required this.length,
  }) : super(key: key);

  @override
  BannerDotsIndicatorState createState() => BannerDotsIndicatorState();
}

class BannerDotsIndicatorState extends State<BannerDotsIndicator> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(widget.length, (index) {
        return Container(
          width: 8.0,
          height: 8.0,
          margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.current == index ? Colors.white : Colors.grey,
          ),
        );
      }),
    );
  }
}
