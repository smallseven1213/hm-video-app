import 'package:flutter/material.dart';
import 'package:shared/models/vod.dart';

import '../../widgets/title_header.dart';
import '../../widgets/video_preview.dart';

class BelongVideo extends StatelessWidget {
  final List<Vod> videos;

  const BelongVideo({super.key, required this.videos});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
            padding: EdgeInsets.all(8), child: TitleHeader(text: '選集')),
        SizedBox(
          height: 115.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: videos.length,
            itemBuilder: (context, index) {
              Vod vod = videos[index];
              return Container(
                width: 150,
                height: 110,
                padding: const EdgeInsets.only(left: 8),
                child: VideoPreviewWidget(
                  id: vod.id,
                  title: vod.title,
                  coverHorizontal: vod.coverHorizontal!,
                  coverVertical: vod.coverVertical!,
                  timeLength: vod.timeLength!,
                  tags: vod.tags!,
                  displayViewTimes: false,
                  displaySupplier: false,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
