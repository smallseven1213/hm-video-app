import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/list_editor_controller.dart';
import 'package:shared/controllers/play_record_controller.dart';
import 'package:shared/models/video_database_field.dart';

import '../../widgets/no_data.dart';
import '../../widgets/video_preview.dart';
import '../../widgets/video_preview_with_edit.dart';

const gridRatio = 128 / 227;

class PlayRecordShortScreen extends StatelessWidget {
  PlayRecordShortScreen({Key? key}) : super(key: key);

  final ListEditorController listEditorController =
      Get.find<ListEditorController>(tag: 'playrecord');
  final shortPlayRecordController =
      Get.find<PlayRecordController>(tag: 'short');

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var videos = shortPlayRecordController.videos;
      if (videos.isEmpty) {
        return const NoDataWidget();
      }
      return GridView.builder(
        itemCount: shortPlayRecordController.videos.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: gridRatio,
          crossAxisSpacing: 1,
          mainAxisSpacing: 1,
        ),
        itemBuilder: (BuildContext context, int index) {
          var vod = shortPlayRecordController.videos.value[index];
          return VideoPreviewWithEditWidget(
              id: vod.id,
              film: 2,
              // onOverrideRedirectTap: () {
              // MyRouteDelegate.of(context).push(
              //   AppRoutes.shortsByTag.value,
              //   args: {'videoId': vod.id, 'tagId': tagId},
              //   removeSamePath: true,
              // );
              // },
              hasRadius: false,
              hasTitle: false,
              imageRatio: gridRatio,
              displayCoverVertical: true,
              coverVertical: vod.coverVertical,
              coverHorizontal: vod.coverHorizontal,
              timeLength: vod.timeLength,
              tags: vod.tags,
              title: vod.title,
              videoViewTimes: vod.videoViewTimes);
        },
      );
    });
  }
}
