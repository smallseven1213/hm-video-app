import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/list_editor_controller.dart';
import 'package:shared/controllers/play_record_controller.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';

import '../../widgets/no_data.dart';
import '../../widgets/video_preview_with_edit.dart';

const gridRatio = 128 / 227;

final logger = Logger();

class PlayRecordShortScreen extends StatelessWidget {
  PlayRecordShortScreen({Key? key}) : super(key: key);

  final ListEditorController listEditorController =
      Get.find<ListEditorController>(tag: 'playrecord');
  final shortPlayRecordController =
      Get.find<PlayRecordController>(tag: 'short');

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var videos = shortPlayRecordController.data;
      if (videos.isEmpty) {
        return const NoDataWidget();
      }
      return GridView.builder(
        itemCount: shortPlayRecordController.data.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: gridRatio,
          crossAxisSpacing: 1,
          mainAxisSpacing: 1,
        ),
        itemBuilder: (BuildContext context, int index) {
          var vod = shortPlayRecordController.data[index];
          logger.i('EDIT MORE TRACE: render item ${vod.id}');
          return Obx(() {
            return VideoPreviewWithEditWidget(
              id: vod.id,
              film: 2,
              isEditing: listEditorController.isEditing.value,
              isSelected: listEditorController.selectedIds.contains(vod.id),
              onEditingTap: () {
                listEditorController.toggleSelected(vod.id);
              },
              onOverrideRedirectTap: (id) {
                MyRouteDelegate.of(context).push(
                  AppRoutes.shortsByLocal.value,
                  args: {'videoId': vod.id, 'itemId': 1},
                );
              },
              displayVideoCollectTimes: false,
              hasRadius: false,
              hasTitle: false,
              hasTags: false,
              imageRatio: gridRatio,
              displayCoverVertical: true,
              coverVertical: vod.coverVertical ?? '',
              coverHorizontal: vod.coverHorizontal ?? '',
              timeLength: vod.timeLength ?? 0,
              tags: vod.tags ?? [],
              title: vod.title,
              videoViewTimes: vod.videoViewTimes ?? 0,
              videoCollectTimes: vod.videoCollectTimes ?? 0,
              displayVideoTimes: false,
              displayViewTimes: false,
            );
          });
        },
      );
    });
  }
}
