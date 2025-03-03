import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:game/models/game_banner_image.dart';
import 'package:game/widgets/banner_item.dart';

class Carousel extends StatefulWidget {
  final List<GameBannerImage>? images;
  final double? ratio;
  const Carousel({
    Key? key,
    required this.images,
    this.ratio = 16 / 9,
  }) : super(key: key);

  @override
  State<Carousel> createState() => CarouselState();
}

class CarouselState extends State<Carousel> {
  var index = 0;

  CarouselSliderController controller = CarouselSliderController();
  void indexChanged(idx) {
    setState(() {
      index = idx;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool multipleImages = widget.images!.length > 1;

    return AspectRatio(
      aspectRatio: widget.ratio ?? 16 / 9,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Stack(
          children: [
            CarouselSlider(
              carouselController: controller,
              options: CarouselOptions(
                aspectRatio: widget.ratio ?? 16 / 9,
                viewportFraction: 1.0,
                enableInfiniteScroll: multipleImages,
                autoPlay: multipleImages,
                onPageChanged:
                    multipleImages ? (val, _) => indexChanged(val) : null,
              ),
              items: widget.images
                  ?.map(
                    (item) => BannerItem(image: item),
                  )
                  .toList(),
            ),
            if (multipleImages)
              Positioned(
                left: 0,
                right: 0,
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
                              onTap: () => controller
                                  .animateToPage(widget.images!.indexOf(item)),
                            ),
                          ))
                      .toList() as List<Widget>,
                ),
              )
          ],
        ),
      ),
    );
  }
}
