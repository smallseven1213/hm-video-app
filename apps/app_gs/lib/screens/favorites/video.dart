import 'package:app_gs/widgets/video_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/list_editor_controller.dart';
import 'package:shared/controllers/user_favorites_video_controlle.dart';
import 'package:shared/models/video_database_field.dart';

import '../../widgets/no_data.dart';
import '../../widgets/video_preview_with_edit.dart';

class FavoritesVideoScreen extends StatelessWidget {
  FavoritesVideoScreen({Key? key}) : super(key: key);

  final ListEditorController listEditorController =
      Get.find<ListEditorController>(tag: 'favorites');
  final userFavoritesVideoController = Get.find<UserFavoritesVideoController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var videos = userFavoritesVideoController.videos;
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
            VideoDatabaseField? video2;
            if (index * 2 + 1 < videos.length) {
              video2 = videos[index * 2 + 1];
            }
            return Row(
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
                      coverVertical: video1.coverVertical,
                      coverHorizontal: video1.coverHorizontal,
                      timeLength: video1.timeLength,
                      tags: video1.tags,
                      title: video1.title,
                      videoViewTimes: video1.videoViewTimes)),
                ),
                const SizedBox(width: 8),
                if (video2 != null)
                  Expanded(
                    child: Obx(() => VideoPreviewWithEditWidget(
                        id: video2!.id,
                        isEditing: listEditorController.isEditing.value,
                        isSelected: listEditorController.selectedIds
                            .contains(video2.id),
                        onEditingTap: () {
                          listEditorController.toggleSelected(video2!.id);
                        },
                        coverVertical: video2.coverVertical,
                        coverHorizontal: video2.coverHorizontal,
                        timeLength: video2.timeLength,
                        tags: video2.tags,
                        title: video2.title,
                        videoViewTimes: video2.videoViewTimes)),
                  ),
              ],
            );
          },
        ),
      );
    });
  }
}
