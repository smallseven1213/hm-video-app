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
  final int? film;
  final bool? displayVideoCollectTimes;
  final bool? displayVideoTimes;
  final bool? displayViewTimes;

  const VideoBlockGridViewRow({
    Key? key,
    required this.videoData,
    this.gridLength = 2,
    this.imageRatio,
    required this.isEmbeddedAds,
    this.blockId,
    this.displayCoverVertical = false,
    this.hasInfoView = true,
    this.displayVideoCollectTimes = true,
    this.displayVideoTimes = true,
    this.displayViewTimes = true,
    this.film = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // logger.i('widget.videoData.length: ${videoData}');
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
              videoCollectTimes: videoData[0].videoCollectTimes ?? 0,
              imageRatio: imageRatio,
              detail: videoData[0],
              isEmbeddedAds: isEmbeddedAds,
              displayCoverVertical: displayCoverVertical ?? false,
              blockId: blockId,
              hasInfoView: hasInfoView,
              film: film,
              displayVideoCollectTimes: displayVideoCollectTimes,
              displayVideoTimes: displayVideoTimes,
              displayViewTimes: displayViewTimes,
            ),
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
                e.id.isNaN || e.id == 0
                    ? const Expanded(
                        child: SizedBox(
                          height: 100,
                          width: double.infinity,
                        ),
                      )
                    : Expanded(
                        child: VideoPreviewWidget(
                          id: e.id,
                          title: e.title,
                          tags: e.tags ?? [],
                          timeLength: e.timeLength ?? 0,
                          coverHorizontal: e.coverHorizontal ?? '',
                          coverVertical: e.coverVertical ?? '',
                          videoViewTimes: e.videoViewTimes ?? 0,
                          videoCollectTimes: e.videoCollectTimes ?? 0,
                          imageRatio: imageRatio,
                          detail: e,
                          isEmbeddedAds: isEmbeddedAds,
                          displayCoverVertical: displayCoverVertical ?? false,
                          blockId: blockId,
                          film: film,
                          displayVideoCollectTimes: displayVideoCollectTimes,
                          displayVideoTimes: displayVideoTimes,
                          displayViewTimes: displayViewTimes,
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
                  id: e.id,
                  title: e.title,
                  tags: e.tags ?? [],
                  timeLength: e.timeLength ?? 0,
                  coverHorizontal: e.coverHorizontal ?? '',
                  coverVertical: e.coverVertical ?? '',
                  videoViewTimes: e.videoViewTimes ?? 0,
                  videoCollectTimes: e.videoCollectTimes ?? 0,
                  imageRatio: imageRatio,
                  detail: e,
                  isEmbeddedAds: isEmbeddedAds,
                  displayCoverVertical: displayCoverVertical ?? false,
                  blockId: blockId,
                  film: film,
                  displayVideoCollectTimes: film == 2,
                  displayVideoTimes: film == 1,
                  displayViewTimes: film == 1,
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
