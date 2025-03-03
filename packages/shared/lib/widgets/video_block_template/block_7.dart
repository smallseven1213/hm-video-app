import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart' hide CarouselSliderController;
import 'package:logger/logger.dart';
import 'package:shared/models/channel_info.dart';
import 'package:shared/models/vod.dart';
import 'package:shared/widgets/sid_image.dart';

import '../base_video_preview.dart';

final logger = Logger();

class Block7Widget extends StatefulWidget {
  final Blocks block;
  final Function updateBlock;
  final int channelId;
  final int film;
  final Color? gradientBgTopColor;
  final Color? gradientBgBottomColor;
  final BaseVideoPreviewWidget Function(Vod video) buildVideoPreview;
  const Block7Widget({
    Key? key,
    required this.block,
    required this.updateBlock,
    required this.channelId,
    required this.film,
    this.gradientBgTopColor = const Color(0xFF040405),
    this.gradientBgBottomColor = const Color.fromRGBO(20, 49, 104, 0.7),
    required this.buildVideoPreview,
  }) : super(key: key);

  @override
  Block7WidgetState createState() => Block7WidgetState();
}

class Block7WidgetState extends State<Block7Widget> {
  String? backgroundPhotoSid;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  // override initial
  @override
  void initState() {
    super.initState();
    List<Vod> videos = widget.block.videos?.data ?? [];

    if (videos.isNotEmpty) {
      setState(() {
        backgroundPhotoSid = videos[0].coverVertical;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Vod> videos = widget.block.videos?.data ?? [];

    return SliverToBoxAdapter(
      child: Container(
        height: 310,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Stack(
          children: [
            backgroundPhotoSid == null
                ? const SizedBox.shrink()
                : ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      width: double.infinity,
                      height: 310,
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: 2.0,
                        child: SidImage(
                          key: ValueKey(backgroundPhotoSid),
                          sid: backgroundPhotoSid!,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      widget.gradientBgTopColor!,
                      widget.gradientBgBottomColor!,
                    ],
                    stops: const [0.0, 1],
                  ),
                ),
              ),
            ),
            CarouselSlider.builder(
                carouselController: _carouselController,
                itemCount: videos.length,
                options: CarouselOptions(
                  autoPlay: false,
                  enlargeCenterPage: true,
                  viewportFraction: 0.45,
                  height: 310,
                  initialPage: 2,
                  onPageChanged: (index, reason) {
                    setState(() {
                      backgroundPhotoSid = videos[index].coverVertical;
                    });
                  },
                ),
                itemBuilder:
                    (BuildContext context, int itemIndex, int pageViewIndex) {
                  var vod = videos[itemIndex];
                  return Center(
                    child: SizedBox(
                      height: 270,
                      width: 160,
                      child: widget.buildVideoPreview(vod),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
