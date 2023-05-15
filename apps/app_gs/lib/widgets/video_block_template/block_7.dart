// Block1Widget

import 'package:app_gs/widgets/video_preview.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared/models/channel_info.dart';
import 'package:shared/models/vod.dart';
import 'package:shared/widgets/sid_image.dart';

final logger = Logger();

class Block7Widget extends StatefulWidget {
  final Blocks block;
  final Function updateBlock;
  final int channelId;
  final int film;
  const Block7Widget({
    Key? key,
    required this.block,
    required this.updateBlock,
    required this.channelId,
    required this.film,
  }) : super(key: key);

  @override
  Block7WidgetState createState() => Block7WidgetState();
}

class Block7WidgetState extends State<Block7Widget> {
  String? backgroundPhotoSid;
  final CarouselController _carouselController = CarouselController();

  // override initial
  @override
  void initState() {
    super.initState();
    List<Vod> videos = widget.block.videos?.data ?? [];
    backgroundPhotoSid = videos[0].coverHorizontal;
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
                        height: 300,
                        child: SidImage(
                          key: ValueKey(backgroundPhotoSid),
                          sid: backgroundPhotoSid!,
                          width: double.infinity,
                          height: 300,
                          fit: BoxFit.fill,
                        )),
                  ),
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    const Color(0xFF040405),
                    const Color(0xFF040405).withOpacity(0.0),
                    const Color.fromRGBO(20, 49, 104, 0.7),
                  ],
                  stops: const [0.0, 0.5, 0.5],
                ),
              ),
            ),
            CarouselSlider.builder(
                carouselController: _carouselController,
                itemCount: videos.length,
                options: CarouselOptions(
                  autoPlay: false,
                  enlargeCenterPage: true,
                  viewportFraction: 0.5,
                  height: 283,
                  initialPage: 2,
                  onPageChanged: (index, reason) {
                    setState(() {
                      logger.i(videos[index].coverHorizontal);
                      backgroundPhotoSid = videos[index].coverHorizontal;
                    });
                  },
                ),
                itemBuilder:
                    (BuildContext context, int itemIndex, int pageViewIndex) {
                  var vod = videos[itemIndex];
                  return Center(
                    child: SizedBox(
                      height: 245,
                      width: 190,
                      child: VideoPreviewWidget(
                        id: vod.id,
                        film: widget.film,
                        displayCoverVertical: true,
                        coverVertical: vod.coverVertical!,
                        coverHorizontal: vod.coverHorizontal!,
                        timeLength: vod.timeLength!,
                        tags: vod.tags!,
                        title: vod.title,
                        imageRatio: 190 / 245,
                        hasTags: false,
                        videoViewTimes: vod.videoViewTimes!,
                        blockId: widget.block.id,
                      ),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
