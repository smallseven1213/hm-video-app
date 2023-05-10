import 'package:app_gs/widgets/video_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/list_editor_controller.dart';
import 'package:shared/controllers/user_favorites_video_controlle.dart';

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
        child: AlignedGridView.count(
          crossAxisCount: 2,
          itemCount: videos.length,
          itemBuilder: (BuildContext context, int index) {
            var video = videos[index];
            return Obx(() => VideoPreviewWithEditWidget(
                id: video.id,
                isEditing: listEditorController.isEditing.value,
                isSelected:
                    listEditorController.selectedIds.contains(videos[index].id),
                onEditingTap: () {
                  listEditorController.toggleSelected(videos[index].id);
                },
                coverVertical: video.coverVertical,
                coverHorizontal: video.coverHorizontal,
                timeLength: video.timeLength,
                tags: video.tags,
                title: video.title,
                videoViewTimes: video.videoViewTimes));
          },
          mainAxisSpacing: 12.0,
          crossAxisSpacing: 10.0,
        ),
      );
    });
  }
}
