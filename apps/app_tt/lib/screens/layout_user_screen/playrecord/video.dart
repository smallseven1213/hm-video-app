import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/list_editor_controller.dart';
import 'package:shared/controllers/play_record_controller.dart';
import 'package:shared/enums/list_editor_category.dart';
import 'package:shared/enums/play_record_type.dart';
import 'package:shared/models/vod.dart';

import '../../../widgets/no_data.dart';
import '../../../widgets/video_preview_with_edit.dart';

class PlayRecordVideoScreen extends StatelessWidget {
  PlayRecordVideoScreen({Key? key}) : super(key: key);

  final ListEditorController listEditorController =
      Get.find<ListEditorController>(
          tag: ListEditorCategory.playrecord.toString());
  final userFavoritesVideoController =
      Get.find<PlayRecordController>(tag: PlayRecordType.video.toString());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var videos = userFavoritesVideoController.data;
      if (videos.isEmpty) {
        return const NoDataWidget();
      }
      return Padding(
        padding: const EdgeInsets.only(top: 10.0, right: 8, left: 8),
        child: CustomScrollView(
          physics: const NeverScrollableScrollPhysics(),
          controller: PrimaryScrollController.of(context),
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  var video1 = videos[index * 2];
                  Vod? video2;
                  if (index * 2 + 1 < videos.length) {
                    video2 = videos[index * 2 + 1];
                  }
                  return Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Obx(() => VideoPreviewWithEditWidget(
                                  id: video1.id,
                                  isEditing:
                                      listEditorController.isEditing.value,
                                  isSelected: listEditorController.selectedIds
                                      .contains(video1.id),
                                  onEditingTap: () {
                                    listEditorController
                                        .toggleSelected(video1.id);
                                  },
                                  coverVertical: video1.coverVertical ?? '',
                                  coverHorizontal: video1.coverHorizontal ?? '',
                                  timeLength: video1.timeLength ?? 0,
                                  tags: video1.tags ?? [],
                                  title: video1.title,
                                  displayVideoFavoriteTimes: false,
                                  videoViewTimes: video1.videoViewTimes!,
                                )),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: video2 != null
                                ? Obx(() => VideoPreviewWithEditWidget(
                                      id: video2!.id,
                                      isEditing:
                                          listEditorController.isEditing.value,
                                      isSelected: listEditorController
                                          .selectedIds
                                          .contains(video2.id),
                                      onEditingTap: () {
                                        listEditorController
                                            .toggleSelected(video2!.id);
                                      },
                                      title: video2.title,
                                      tags: video2.tags ?? [],
                                      timeLength: video2.timeLength ?? 0,
                                      coverHorizontal:
                                          video2.coverHorizontal ?? '',
                                      coverVertical: video2.coverVertical ?? '',
                                      videoViewTimes: video2.videoViewTimes!,
                                      displayVideoFavoriteTimes: false,
                                    ))
                                : const SizedBox(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8), // 替代 separatorBuilder
                    ],
                  );
                },
                childCount: (videos.length / 2).ceil(),
              ),
            ),
          ],
        ),
      );
    });
  }
}
