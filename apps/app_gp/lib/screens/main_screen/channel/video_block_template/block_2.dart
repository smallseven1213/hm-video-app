// Block1Widget

import 'package:app_gp/widgets/video_preview.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/channel_info.dart';

class Block2Widget extends StatelessWidget {
  List<Data> videos = [];
  Block2Widget({Key? key, required this.videos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        padding: const EdgeInsets.all(10),
        children: List.generate(
            10,
            (index) => Container(
                  width: double.infinity,
                  height: 60,
                  color: Colors.white,
                )));
    // children: List.generate(
    //   10,
    //   (index) => VideoPreviewWidget(
    //     title: videos[index].title ?? '',
    //     tags: videos[index].tags ?? [],
    //     timeLength: videos[index].timeLength ?? 0,
    //     coverHorizontal: videos[index].coverHorizontal ?? '',
    //     coverVertical: videos[index].coverVertical ?? '',
    //     videoViewTimes: videos[index].videoViewTimes ?? 0,
    //   ),
    // ));
  }
}
