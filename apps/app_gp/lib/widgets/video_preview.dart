// VideoPreviewWidget, has props: String sid, String duration, String[] tags, String title, String previewCount, String types

import 'package:flutter/material.dart';
import 'package:shared/models/channel_info.dart';
import 'package:shared/widgets/sid_image.dart';

class VideoPreviewWidget extends StatelessWidget {
  final String coverVertical;
  final String coverHorizontal;
  final int timeLength;
  final List<Tags> tags;
  final String title;
  final int videoViewTimes;
  const VideoPreviewWidget({
    Key? key,
    required this.coverVertical,
    required this.coverHorizontal,
    required this.timeLength,
    required this.tags,
    required this.title,
    required this.videoViewTimes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          height: 101,
          width: double.infinity,
          child: SidImage(
              sid: coverHorizontal,
              width: double.infinity,
              height: 101,
              fit: BoxFit.cover),
        ),
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ),
        Row(
          children: tags
              .map((e) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                      color: const Color(0xff4277DC).withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    e.name ?? '',
                    style: const TextStyle(
                      color: Color(0xff21AFFF),
                      fontSize: 10,
                    ),
                  )))
              .toList()
              .map((widget) => Row(
                    children: [
                      widget,
                      const SizedBox(width: 10),
                    ],
                  ))
              .toList(),
        )
      ],
    );
    // return Container(
    //     width: double.infinity,
    //     height: 101,
    //     child: Stack(
    //       children: [
    // SidImage(
    //     sid: coverHorizontal,
    //     width: double.infinity,
    //     height: 101,
    //     fit: BoxFit.cover)
    //       ],
    //     ));
  }
}
