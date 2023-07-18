// Block1Widget

import 'package:app_gs/widgets/video_preview.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
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
    setState(() {
      backgroundPhotoSid = videos[2].coverHorizontal;
    });
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
                      // child: Stack(
                      //   alignment: Alignment.centerLeft,
                      //   children: [
                      //     FractionallySizedBox(
                      //       widthFactor: 2.0,
                      //       child: SidImage(
                      //         key: ValueKey(backgroundPhotoSid),
                      //         sid: backgroundPhotoSid!,
                      //         width: double.infinity,
                      //         fit: BoxFit.cover,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ),
                  ),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: kIsWeb
                    ? null
                    : const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color(0xFF040405),
                            Color.fromRGBO(20, 49, 104, 0.7),
                          ],
                          stops: [0.0, 1],
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
                      height: 267,
                      width: 160,
                      child: VideoPreviewWidget(
                        id: vod.id,
                        film: widget.film,
                        displayCoverVertical: true,
                        coverVertical: vod.coverVertical!,
                        coverHorizontal: vod.coverHorizontal!,
                        timeLength: vod.timeLength!,
                        tags: vod.tags!,
                        title: vod.title,
                        imageRatio: 160 / 245,
                        hasTags: false,
                        videoViewTimes: vod.videoViewTimes!,
                        videoCollectTimes: vod.videoCollectTimes!,
                        blockId: widget.block.id,
                        displayVideoTimes: widget.film == 1,
                        displayViewTimes: widget.film == 1,
                        displayVideoCollectTimes: widget.film == 2,
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
