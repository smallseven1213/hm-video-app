import 'package:app_51ss/config/user_tab.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/list_editor_controller.dart';
import 'package:shared/enums/list_editor_category.dart';
import 'package:shared/models/vod.dart';

import '../../widgets/no_data.dart';
import '../../widgets/video_preview_with_edit.dart';

class CollectionVideo extends StatelessWidget {
  CollectionVideo({super.key});

  final ListEditorController listEditorController =
      Get.find<ListEditorController>(
          tag: ListEditorCategory.collection.toString());
  final userCollectionVideoController =
      userTabControllers['collection']!.controller;

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
                      displayVideoCollectTimes: false,
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
                      ? Obx(() => VideoPreviewWithEditWidget(
                          id: video2!.id,
                          displayVideoCollectTimes: false,
                          isEditing: listEditorController.isEditing.value,
                          isSelected: listEditorController.selectedIds
                              .contains(video2.id),
                          onEditingTap: () {
                            listEditorController.toggleSelected(video2!.id);
                          },
                          coverVertical: video2.coverVertical ?? '',
                          coverHorizontal: video2.coverHorizontal ?? '',
                          timeLength: video2.timeLength ?? 0,
                          tags: video2.tags ?? [],
                          title: video2.title,
                          videoViewTimes: video2.videoViewTimes!))
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
