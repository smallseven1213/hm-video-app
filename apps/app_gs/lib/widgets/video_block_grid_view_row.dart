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

  Widget _buildVideoPreviewWidget(Vod video) {
    return Expanded(
      child: VideoPreviewWidget(
        id: video.id,
        title: video.title,
        tags: video.tags ?? [],
        timeLength: video.timeLength ?? 0,
        coverHorizontal: video.coverHorizontal ?? '',
        coverVertical: video.coverVertical ?? '',
        videoViewTimes: video.videoViewTimes ?? 0,
        videoCollectTimes: video.videoCollectTimes ?? 0,
        imageRatio: imageRatio,
        detail: video,
        isEmbeddedAds: isEmbeddedAds,
        displayCoverVertical: displayCoverVertical ?? false,
        blockId: blockId,
        film: film,
        displayVideoCollectTimes: displayVideoCollectTimes,
        displayVideoTimes: displayVideoTimes,
        displayViewTimes: displayViewTimes,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // logger.i('widget.videoData.length: ${videoData}');
    if (gridLength == 3) {
      if (videoData.length == 2) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildVideoPreviewWidget(videoData[0])),
            const SizedBox(width: 10),
            Expanded(child: _buildVideoPreviewWidget(videoData[1])),
            const SizedBox(width: 10),
            const Expanded(
              child: SizedBox(
                height: 100,
                width: double.infinity,
              ),
            ),
          ],
        );
      }
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
                if (videoData.length == 1)
                  for (var i = 0; i < 2; i++) ...[
                    const Expanded(
                      child: SizedBox(
                        height: 100,
                        width: double.infinity,
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
              ],
            )
            .toList()
          ..removeLast(),
      );
    } else if (gridLength != 3 && videoData.length == 1) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _buildVideoPreviewWidget(videoData[0])),
          const SizedBox(width: 10),
          const Expanded(
            child: SizedBox(
              height: 100,
              width: double.infinity,
            ),
          ),
        ],
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
}
