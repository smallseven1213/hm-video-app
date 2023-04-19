import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/banner_controller.dart';
import 'package:shared/models/channel_info.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared/widgets/sid_image.dart';
import 'package:shared/widgets/ad_banner.dart';

class Carousel extends StatefulWidget {
  final List<BannerImage>? images;
  const Carousel({
    Key? key,
    required this.images,
  }) : super(key: key);

  @override
  State<Carousel> createState() => CarouselState();
}

class CarouselState extends State<Carousel> {
  var index = 0;

  CarouselController controller = CarouselController();
  void indexChanged(idx) {
    setState(() {
      index = idx;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Stack(
        children: [
          widget.images!.length > 1
              ? Container(
                  foregroundDecoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.0),
                        Colors.black.withOpacity(0.3),
                      ],
                      stops: const [0.9, 1.0],
                    ),
                  ),
                  child: CarouselSlider(
                    carouselController: controller,
                    options: CarouselOptions(
                      viewportFraction: 1.0,
                      enableInfiniteScroll: true,
                      autoPlay: true,
                      onPageChanged: (val, _) => indexChanged(val),
                    ),
                    items: widget.images
                        ?.map(
                          (item) => AspectRatio(
                              aspectRatio: 16 / 9,
                              child: AdBanner(image: item)),
                        )
                        .toList(),
                  ),
                )
              : AspectRatio(
                  aspectRatio: 16 / 9,
                  child: AdBanner(image: widget.images![0]),
                ),
          widget.images!.length > 1
              ? Positioned(
                  right: 10,
                  bottom: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: widget.images
                        ?.map((item) => Container(
                              width: 20,
                              height: 5,
                              margin: const EdgeInsets.only(
                                  bottom: 8, left: 2, right: 2),
                              decoration: BoxDecoration(
                                color: widget.images!.indexOf(item) == index
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: InkWell(
                                onTap: () => controller.animateToPage(
                                    widget.images!.indexOf(item)),
                              ),
                            ))
                        .toList() as List<Widget>,
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
