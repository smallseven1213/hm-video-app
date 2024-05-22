// VideoScreen stateless
import 'package:flutter/material.dart';
import 'package:shared/models/index.dart';
import '../../../widgets/video_preview.dart';
import 'enums.dart';

class VideoList extends StatelessWidget {
  final List<Vod> videos;
  final VideoFilterType? category;
  final TabController? tabController;

  const VideoList({
    super.key,
    required this.videos,
    this.category,
    this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    int totalRows = (videos.length / 2).ceil();
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          int firstVideoIndex = index * 2;
          int secondVideoIndex = firstVideoIndex + 1;

          var firstVideo = videos[firstVideoIndex];
          var secondVideo = secondVideoIndex < videos.length
              ? videos[secondVideoIndex]
              : null;

          return Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: VideoPreviewWidget(
                      id: firstVideo.id,
                      coverVertical: firstVideo.coverVertical!,
                      coverHorizontal: firstVideo.coverHorizontal!,
                      timeLength: firstVideo.timeLength!,
                      tags: firstVideo.tags!,
                      title: firstVideo.title,
                      videoViewTimes: firstVideo.videoViewTimes!,
                      videoFavoriteTimes: firstVideo.videoFavoriteTimes!,
                      displayVideoFavoriteTimes: false,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: secondVideo != null
                        ? VideoPreviewWidget(
                            id: secondVideo.id,
                            coverVertical: secondVideo.coverVertical!,
                            coverHorizontal: secondVideo.coverHorizontal!,
                            timeLength: secondVideo.timeLength!,
                            tags: secondVideo.tags!,
                            title: secondVideo.title,
                            videoViewTimes: secondVideo.videoViewTimes!,
                            videoFavoriteTimes: secondVideo.videoFavoriteTimes!,
                            displayVideoFavoriteTimes: false,
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          );
        },
        childCount: totalRows,
      ),
    );
  }
}
