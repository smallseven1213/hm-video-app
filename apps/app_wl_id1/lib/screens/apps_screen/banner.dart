import 'package:app_wl_id1/widgets/carousel.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared/models/index.dart';
import 'package:shared/modules/banner/banner_consumer.dart';

final logger = Logger();

class BannerWidget extends StatefulWidget {
  const BannerWidget({
    Key? key,
  }) : super(key: key);

  @override
  BannerWidgetState createState() => BannerWidgetState();
}

class BannerWidgetState extends State<BannerWidget> {
  @override
  Widget build(BuildContext context) {
    return BannerConsumer(
        position: BannerPosition.discoverCarousel,
        child: (banners) => Carousel(
              images: banners,
              ratio: 359 / 170,
            ));
  }
}
