import 'package:flutter/material.dart';
import 'package:shared/models/index.dart';
import 'package:shared/widgets/base_video_preview.dart';
import 'package:shared/widgets/sid_image.dart';
import 'package:shared/widgets/video/video_time.dart';
import 'package:shared/widgets/visibility_detector.dart';

class ShortVideoPreviewWidget extends BaseVideoPreviewWidget {
  const ShortVideoPreviewWidget({
    Key? key,
    required int id,
    required String coverVertical,
    required String coverHorizontal,
    bool displayCoverVertical = false,
    required int timeLength,
    required List<Tag> tags,
    required String title,
    int? videoViewTimes = 0,
    int? videoCollectTimes = 0,
    bool isEmbeddedAds = false,
    Vod? detail,
    double? imageRatio,
    int? film = 1,
    bool? hasTags = true,
    bool? hasInfoView = true,
    int? blockId,
    bool? hasRadius = true,
    bool? hasTitle = true,
    Function()? onTap,
    bool? hasTapEvent = true,
    Function(int id)? onOverrideRedirectTap,
    bool? displayVideoCollectTimes = true,
    bool? displayVideoTimes = true,
    bool? displayViewTimes = true,
    bool? displaySupplier = true,
  }) : super(
          key: key,
          id: id,
          coverVertical: coverVertical,
          coverHorizontal: coverHorizontal,
          displayCoverVertical: displayCoverVertical,
          timeLength: timeLength,
          tags: tags,
          title: title,
          videoViewTimes: videoViewTimes,
          videoCollectTimes: videoCollectTimes,
          isEmbeddedAds: isEmbeddedAds,
          detail: detail,
          imageRatio: imageRatio,
          film: film,
          hasTags: hasTags,
          hasInfoView: hasInfoView,
          blockId: blockId,
          hasRadius: hasRadius,
          hasTitle: hasTitle,
          onTap: onTap,
          hasTapEvent: hasTapEvent,
          onOverrideRedirectTap: onOverrideRedirectTap,
          displayVideoCollectTimes: displayVideoCollectTimes,
          displayVideoTimes: displayVideoTimes,
          displayViewTimes: displayViewTimes,
          displaySupplier: displaySupplier,
        );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => super.onVideoTap(context),
      child: AspectRatio(
        aspectRatio: imageRatio ?? 128 / 173,
        child: Stack(
          children: [
            // 影片封面
            AspectRatio(
              aspectRatio: imageRatio ?? 128 / 173,
              child: SidImageVisibilityDetector(
                child: SidImage(
                  key: ValueKey('video-preview-$id'),
                  sid: displayCoverVertical ? coverVertical : coverHorizontal,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // bottom 0, container, height 30, vertical gradient background: transparent -> black(80%)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                width: double.infinity,
                height: 30,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black87,
                    ],
                  ),
                ),
                child: Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // in children: left is play button and flex 1 , right is video time and width by content
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: 30,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 4,
                              ),
                              // const Image(
                              //   width: 15,
                              //   height: 17,
                              //   image:
                              //       AssetImage('assets/images/play_count.webp'),
                              // ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                videoViewTimes.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(right: 5),
                        child: VideoTime(time: timeLength),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
