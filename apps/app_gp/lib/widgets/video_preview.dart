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
  final double? imageRatio;
  const VideoPreviewWidget({
    Key? key,
    required this.coverVertical,
    required this.coverHorizontal,
    required this.timeLength,
    required this.tags,
    required this.title,
    required this.videoViewTimes,
    this.imageRatio,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            // 上面轉成AspectRatio
            AspectRatio(
              aspectRatio: imageRatio ?? 182 / 101.93,
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.white,
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: SidImage(
                    sid: coverHorizontal,
                    width: double.infinity,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
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
            const SizedBox(height: 5),
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
      },
    );
  }
}
