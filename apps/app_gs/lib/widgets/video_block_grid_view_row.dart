import 'package:flutter/material.dart';
import 'package:shared/models/index.dart';

import 'video_preview.dart';

class VideoBlockGridViewRow extends StatelessWidget {
  final List<Vod> videoData;
  final int gridLength;
  final double? imageRatio;
  final bool isEmbeddedAds;
  final bool? displayCoverVertical;
  final int? blockId;
  final bool? hasInfoView;

  const VideoBlockGridViewRow({
    Key? key,
    required this.videoData,
    this.gridLength = 2,
    this.imageRatio,
    required this.isEmbeddedAds,
    this.blockId,
    this.displayCoverVertical = false,
    this.hasInfoView = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print('widget.videoData.length: ${videoData}');
    if (videoData.length == 1) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: VideoPreviewWidget(
                id: videoData[0].id,
                title: videoData[0].title,
                tags: videoData[0].tags ?? [],
                timeLength: videoData[0].timeLength ?? 0,
                coverHorizontal: videoData[0].coverHorizontal ?? '',
                coverVertical: videoData[0].coverVertical ?? '',
                videoViewTimes: videoData[0].videoViewTimes ?? 0,
                imageRatio: imageRatio,
                detail: videoData[0],
                isEmbeddedAds: isEmbeddedAds,
                displayCoverVertical: displayCoverVertical ?? false,
                blockId: blockId,
                hasInfoView: hasInfoView),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: SizedBox(
              height: 100,
              width: double.infinity,
            ),
          ),
        ],
      );
    } else if (gridLength == 3) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: videoData
            .expand(
              (e) => [
                e.id == null
                    ? const Expanded(
                        child: SizedBox(
                          height: 100,
                          width: double.infinity,
                        ),
                      )
                    : Expanded(
                        child: VideoPreviewWidget(
                          id: e.id!,
                          title: e.title ?? '精彩好片',
                          tags: e.tags ?? [],
                          timeLength: e.timeLength ?? 0,
                          coverHorizontal: e.coverHorizontal ?? '',
                          coverVertical: e.coverVertical ?? '',
                          videoViewTimes: e.videoViewTimes ?? 0,
                          imageRatio: imageRatio,
                          detail: e,
                          isEmbeddedAds: isEmbeddedAds,
                          displayCoverVertical: displayCoverVertical ?? false,
                        ),
                      ),
                const SizedBox(width: 10),
              ],
            )
            .toList()
          ..removeLast(),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: videoData
          .expand(
            (e) => [
              Expanded(
                child: VideoPreviewWidget(
                  id: e.id!,
                  title: e.title ?? '精彩好片',
                  tags: e.tags ?? [],
                  timeLength: e.timeLength ?? 0,
                  coverHorizontal: e.coverHorizontal ?? '',
                  coverVertical: e.coverVertical ?? '',
                  videoViewTimes: e.videoViewTimes ?? 0,
                  imageRatio: imageRatio,
                  detail: e,
                  isEmbeddedAds: isEmbeddedAds,
                  displayCoverVertical: displayCoverVertical ?? false,
                ),
              ),
              const SizedBox(width: 10),
            ],
          )
          .toList()
        ..removeLast(),
    );
  }
}
