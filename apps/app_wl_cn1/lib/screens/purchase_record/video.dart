import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/user_video_purchase_record_controller.dart';
import 'package:shared/models/vod.dart';

import '../../widgets/no_data.dart';
import '../../widgets/video_preview_with_edit.dart';

class PurchaseRecordVideoScreen extends StatelessWidget {
  PurchaseRecordVideoScreen({Key? key}) : super(key: key);

  final userVodPurchaseRecordController =
      Get.find<UserVodPurchaseRecordController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var videos = userVodPurchaseRecordController.videos;
      if (videos.isEmpty) {
        return const NoDataWidget();
      }
      return Padding(
        padding: const EdgeInsets.only(top: 10.0, right: 8, left: 8),
        child: ListView.separated(
          itemCount: (videos.length / 2).ceil(),
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(height: 8);
          },
          itemBuilder: (BuildContext context, int index) {
            var video1 = videos[index * 2];
            Vod? video2;
            if (index * 2 + 1 < videos.length) {
              video2 = videos[index * 2 + 1];
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: VideoPreviewWithEditWidget(
                      id: video1.id,
                      isEditing: false,
                      isSelected: false,
                      coverVertical: video1.coverVertical ?? '',
                      coverHorizontal: video1.coverHorizontal ?? '',
                      timeLength: video1.timeLength ?? 0,
                      tags: video1.tags ?? [],
                      title: video1.title,
                      displayVideoFavoriteTimes: false,
                      videoViewTimes: video1.videoViewTimes!),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: video2 != null
                      ? VideoPreviewWithEditWidget(
                          id: video2.id,
                          isEditing: false,
                          isSelected: false,
                          coverVertical: video2.coverVertical ?? '',
                          coverHorizontal: video2.coverHorizontal ?? '',
                          timeLength: video2.timeLength ?? 0,
                          tags: video2.tags ?? [],
                          title: video2.title,
                          videoViewTimes: video2.videoViewTimes!,
                          displayVideoFavoriteTimes: false,
                        )
                      : const SizedBox(),
                ),
              ],
            );
          },
        ),
      );
    });
  }
}
