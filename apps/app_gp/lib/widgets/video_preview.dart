// VideoPreviewWidget, has props: String sid, String duration, String[] tags, String title, String previewCount, String types

import 'package:app_gp/widgets/video_embedded_ad.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/index.dart';
import 'package:shared/widgets/banner_link.dart';
import 'package:shared/widgets/sid_image.dart';
import 'package:shared/utils/video_info_formatter.dart';

class ViewInfo extends StatelessWidget {
  final int viewCount;
  final String duration;

  const ViewInfo({Key? key, required this.viewCount, required this.duration})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(10)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.1),
            Colors.black.withOpacity(0.7),
          ],
          stops: const [0.05, 1.0],
        ),
        // color: Colors.black.withOpacity(0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                Icons.remove_red_eye_outlined,
                color: Colors.white,
                size: 16,
              ),
              const SizedBox(width: 5),
              Text(
                '$viewCount',
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          Text(
            duration,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class VideoPreviewWidget extends StatelessWidget {
  final String coverVertical;
  final String coverHorizontal;
  final int timeLength;
  final List<Tags> tags;
  final String title;
  final int videoViewTimes;
  final double? imageRatio;
  final Data detail;
  final bool isEmbeddedAds;
  const VideoPreviewWidget({
    Key? key,
    required this.coverVertical,
    required this.coverHorizontal,
    required this.timeLength,
    required this.tags,
    required this.title,
    required this.videoViewTimes,
    required this.isEmbeddedAds,
    required this.detail,
    this.imageRatio,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (detail.dataType == VideoType.embeddedAd.index && isEmbeddedAds) {
      return VideoEmbeddedAdWidget(
        imageRatio: imageRatio ?? 374 / 198,
        detail: detail,
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: imageRatio ?? 374 / 198,
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.white,
                    ),
                    foregroundDecoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.0),
                          Colors.black.withOpacity(0.3),
                        ],
                        stops: const [0.9, 1.0],
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: SidImage(
                      sid: coverHorizontal,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                AspectRatio(
                  aspectRatio: imageRatio ?? 374 / 198,
                  child: Align(
                    alignment: AlignmentDirectional.bottomEnd,
                    child: ViewInfo(
                      viewCount: videoViewTimes,
                      duration: getTimeString(timeLength),
                    ),
                  ),
                ),
              ],
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
            if (tags.isNotEmpty)
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
            else
              const SizedBox(
                height: 15,
              ),
          ],
        );
      },
    );
  }
}
