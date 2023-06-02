// CollectionVideo class, is a stateless widget
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/list_editor_controller.dart';
import 'package:shared/controllers/user_video_collection_controller.dart';
import 'package:shared/models/vod.dart';
import 'package:shared/navigator/delegate.dart';

import '../../widgets/no_data.dart';
import '../../widgets/video_preview_with_edit.dart';

class CollectionVideo extends StatelessWidget {
  CollectionVideo({super.key});

  final ListEditorController listEditorController =
      Get.find<ListEditorController>(tag: 'collection');
  final userCollectionVideoController = Get.find<UserVodCollectionController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var videos = userCollectionVideoController.videos;
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
                  child: Obx(() => VideoPreviewWithEditWidget(
                      id: video1.id,
                      isEditing: listEditorController.isEditing.value,
                      isSelected:
                          listEditorController.selectedIds.contains(video1.id),
                      onEditingTap: () {
                        listEditorController.toggleSelected(video1.id);
                      },
                      coverVertical: video1.coverVertical ?? '',
                      coverHorizontal: video1.coverHorizontal ?? '',
                      timeLength: video1.timeLength ?? 0,
                      tags: video1.tags ?? [],
                      title: video1.title,
                      videoViewTimes: video1.videoViewTimes!)),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: video2 != null
                      ? VideoPreviewWithEditWidget(
                          id: video2.id,
                          isEditing: listEditorController.isEditing.value,
                          isSelected: listEditorController.selectedIds
                              .contains(video2.id),
                          onEditingTap: () {
                            listEditorController.toggleSelected(video2!.id);
                          },
                          title: video2.title,
                          tags: video2.tags ?? [],
                          timeLength: video2.timeLength ?? 0,
                          coverHorizontal: video2.coverHorizontal ?? '',
                          coverVertical: video2.coverVertical ?? '',
                          videoViewTimes: video2.videoViewTimes!,
                          // detail: video2.detail,
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
