// Block1Widget

import 'package:app_gs/widgets/video_preview.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/channel_info.dart';

class Block7Widget extends StatelessWidget {
  final Blocks block;
  final Function updateBlock;
  final int channelId;
  const Block7Widget({
    Key? key,
    required this.block,
    required this.updateBlock,
    required this.channelId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Data> videos = block.videos?.data ?? [];

    return SliverToBoxAdapter(
      child: Container(
        height: 310,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: CarouselSlider.builder(
            itemCount: videos.length,
            options: CarouselOptions(
              autoPlay: false,
              enlargeCenterPage: true,
              viewportFraction: 0.5,
              height: 277,
              initialPage: 2,
            ),
            itemBuilder:
                (BuildContext context, int itemIndex, int pageViewIndex) {
              var vod = videos[itemIndex];
              return Center(
                child: SizedBox(
                  height: 245,
                  child: VideoPreviewWidget(
                      id: vod.id!,
                      displaycoverVertical: true,
                      coverVertical: vod.coverVertical!,
                      coverHorizontal: vod.coverHorizontal!,
                      timeLength: vod.timeLength!,
                      tags: vod.tags!,
                      title: vod.title!,
                      imageRatio: 190 / 245,
                      noTags: true,
                      videoViewTimes: vod.videoViewTimes!),
                ),
              );
            }),
      ),
    );
    // return GridView.count(
    //     crossAxisCount: 2,
    //     shrinkWrap: true,
    //     physics: const NeverScrollableScrollPhysics(),
    //     mainAxisSpacing: 10,
    //     crossAxisSpacing: 10,
    //     padding: const EdgeInsets.all(10),
    //     children: List.generate(
    //         10,
    //         (index) => Container(
    //               width: double.infinity,
    //               height: 60,
    //               color: Colors.white,
    //             )));
  }
}
