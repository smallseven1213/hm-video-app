// VideoPreviewWidget, has props: String sid, String duration, String[] tags, String title, String previewCount, String types

import 'package:app_gp/widgets/video_embedded_ad.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/list_editor_controller.dart';
import 'package:shared/controllers/play_record_controller.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/models/index.dart';
import 'package:shared/models/video_database_field.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/widgets/sid_image.dart';
import 'package:shared/utils/video_info_formatter.dart';

final logger = Logger();

class ViewInfo extends StatelessWidget {
  final int viewCount;
  final String duration;

  const ViewInfo({Key? key, required this.viewCount, required this.duration})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(5),
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
  final int id;
  final String coverVertical;
  final String coverHorizontal;
  final bool displaycoverVertical;
  final int timeLength;
  final List<Tag> tags;
  final String title;
  final int videoViewTimes;
  final double? imageRatio;
  final Data? detail;
  final bool isEmbeddedAds;
  final bool isEditing;
  final bool isSelected;
  final Function()? onEditingTap;

  VideoPreviewWidget({
    Key? key,
    required this.id,
    required this.coverVertical,
    required this.coverHorizontal,
    this.displaycoverVertical = false,
    required this.timeLength,
    required this.tags,
    required this.title,
    required this.videoViewTimes,
    this.isEmbeddedAds = false,
    this.detail,
    this.isEditing = false,
    this.isSelected = false,
    this.imageRatio,
    this.onEditingTap,
  }) : super(key: key);

  final playrecordController = Get.find<PlayRecordController>();

  @override
  Widget build(BuildContext context) {
    if (detail?.dataType == VideoType.embeddedAd.index && isEmbeddedAds) {
      return VideoEmbeddedAdWidget(
        imageRatio: imageRatio ?? 374 / 198,
        detail: detail!,
      );
    }
    return Column(
      children: [
        Stack(
          children: [
            InkWell(
              onTap: isEditing
                  ? onEditingTap
                  : () {
                      MyRouteDelegate.of(context).push(AppRoutes.video.value,
                          args: {
                            'id': id,
                          },
                          removeSamePath: true);
                      var playRecord = VideoDatabaseField(
                        id: id,
                        coverHorizontal: coverHorizontal,
                        coverVertical: coverVertical,
                        timeLength: timeLength,
                        tags: tags,
                        title: title,
                        videoViewTimes: videoViewTimes,
                        detail: detail!,
                      );
                      playrecordController.addPlayRecord(playRecord);
                    },
              child: Stack(
                children: [
                  AspectRatio(
                    aspectRatio: imageRatio ??
                        (displaycoverVertical == true ? 119 / 179 : 374 / 198),
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
                        key: ValueKey('video-preview-$id'),
                        sid: displaycoverVertical
                            ? coverVertical
                            : coverHorizontal,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  if (isEditing &&
                      isSelected) // Check if isEditing is true and the id is in the selectedIds list
                    AspectRatio(
                      aspectRatio: imageRatio ?? 374 / 198,
                      child: Container(
                        color: Colors.black.withOpacity(
                            0.5), // Add a black semi-transparent overlay
                      ),
                    ),
                  if (isEditing && isSelected)
                    const Positioned(
                        top: 4,
                        right: 4,
                        child: Image(
                          image: AssetImage('assets/images/video_selected.png'),
                          width: 20,
                          height: 20,
                        ))
                ],
              ),
            ),
            imageRatio != BlockImageRatio.block4.ratio
                ? AspectRatio(
                    aspectRatio: imageRatio ?? 374 / 198,
                    child: Align(
                      alignment: AlignmentDirectional.bottomEnd,
                      child: ViewInfo(
                        viewCount: videoViewTimes,
                        duration: getTimeString(timeLength),
                      ),
                    ),
                  )
                : const SizedBox(),
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
        if (tags.isNotEmpty) ...[
          const SizedBox(height: 5),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              clipBehavior: Clip.antiAlias,
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.start,
                spacing: 5.0,
                runSpacing: 5.0,
                clipBehavior: Clip.antiAlias,
                children: tags
                    .map((e) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                            color: const Color(0xff4277DC).withOpacity(0.5),
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          e.name,
                          style: const TextStyle(
                            color: Color(0xff21AFFF),
                            fontSize: 10,
                            height: 1.4,
                          ),
                        )))
                    .toList(),
              ),
            ),
          )
        ]
      ],
    );
  }
}
