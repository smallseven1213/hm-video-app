import 'package:flutter/material.dart';
import 'package:shared/models/index.dart';
import 'package:shared/widgets/base_video_preview.dart';

class VideoBlockGridViewRow extends StatelessWidget {
  final List<Vod> videoData;
  final int gridLength;
  final double? imageRatio;
  final bool isEmbeddedAds;
  final bool? displayCoverVertical;
  final int? blockId;
  final bool? hasInfoView;
  final int? film;
  final bool? displayVideoFavoriteTimes;
  final bool? displayVideoTimes;
  final bool? displayViewTimes;
  final BaseVideoPreviewWidget Function(Vod video) buildVideoPreview;

  const VideoBlockGridViewRow({
    Key? key,
    required this.videoData,
    this.gridLength = 2,
    this.imageRatio,
    required this.isEmbeddedAds,
    this.blockId,
    this.displayCoverVertical = false,
    this.hasInfoView = true,
    this.displayVideoFavoriteTimes = true,
    this.displayVideoTimes = true,
    this.displayViewTimes = true,
    this.film = 1,
    required this.buildVideoPreview,
  }) : super(key: key);

  Widget _buildVideoPreviewWidget(Vod video) {
    return Expanded(child: buildVideoPreview(video)
        // VideoPreviewWidget(
        //   id: video.id,
        //   title: video.title,
        //   tags: video.tags ?? [],
        //   timeLength: video.timeLength ?? 0,
        //   coverHorizontal: video.coverHorizontal ?? '',
        //   coverVertical: video.coverVertical ?? '',
        //   videoViewTimes: video.videoViewTimes ?? 0,
        //   videoFavoriteTimes: video.videoFavoriteTimes ?? 0,
        //   imageRatio: imageRatio,
        //   detail: video,
        //   isEmbeddedAds: isEmbeddedAds,
        //   displayCoverVertical: displayCoverVertical ?? false,
        //   blockId: blockId,
        //   film: film,
        //   displayVideoFavoriteTimes: displayVideoFavoriteTimes,
        //   displayVideoTimes: displayVideoTimes,
        //   displayViewTimes: displayViewTimes,
        // ),
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
                    : Expanded(child: buildVideoPreview(e)
                        // VideoPreviewWidget(
                        //   id: e.id,
                        //   title: e.title,
                        //   tags: e.tags ?? [],
                        //   timeLength: e.timeLength ?? 0,
                        //   coverHorizontal: e.coverHorizontal ?? '',
                        //   coverVertical: e.coverVertical ?? '',
                        //   videoViewTimes: e.videoViewTimes ?? 0,
                        //   videoFavoriteTimes: e.videoFavoriteTimes ?? 0,
                        //   imageRatio: imageRatio,
                        //   detail: e,
                        //   isEmbeddedAds: isEmbeddedAds,
                        //   displayCoverVertical: displayCoverVertical ?? false,
                        //   blockId: blockId,
                        //   film: film,
                        //   displayVideoFavoriteTimes: displayVideoFavoriteTimes,
                        //   displayVideoTimes: displayVideoTimes,
                        //   displayViewTimes: displayViewTimes,
                        // ),
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
                child: buildVideoPreview(e),
                // child: VideoPreviewWidget(
                //   id: e.id,
                //   title: e.title,
                //   tags: e.tags ?? [],
                //   timeLength: e.timeLength ?? 0,
                //   coverHorizontal: e.coverHorizontal ?? '',
                //   coverVertical: e.coverVertical ?? '',
                //   videoViewTimes: e.videoViewTimes ?? 0,
                //   videoFavoriteTimes: e.videoFavoriteTimes ?? 0,
                //   imageRatio: imageRatio,
                //   detail: e,
                //   isEmbeddedAds: isEmbeddedAds,
                //   displayCoverVertical: displayCoverVertical ?? false,
                //   blockId: blockId,
                //   film: film,
                //   displayVideoFavoriteTimes: displayVideoFavoriteTimes,
                //   displayVideoTimes: displayVideoTimes,
                //   displayViewTimes: displayViewTimes,
                // ),
              ),
              const SizedBox(width: 10),
            ],
          )
          .toList()
        ..removeLast(),
    );
  }
}
