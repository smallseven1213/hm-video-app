import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/list_editor_controller.dart';
import 'package:shared/controllers/user_short_collection_controller.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/enums/list_editor_category.dart';
import 'package:shared/navigator/delegate.dart';

import '../../../widgets/no_data.dart';
import '../../../widgets/video_preview_with_edit.dart';

const gridRatio = 128 / 227;

final logger = Logger();

class CollectionShortScreen extends StatelessWidget {
  CollectionShortScreen({Key? key}) : super(key: key);

  final ListEditorController listEditorController =
      Get.find<ListEditorController>(
          tag: ListEditorCategory.collection.toString());
  final shortPlayRecordController = Get.find<UserShortCollectionController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var videos = shortPlayRecordController.data;
      logger.i('TESTING PLAY RECORD SHORT SCREEN - $videos');
      if (videos.isEmpty) {
        return const NoDataWidget();
      }
      return CustomScrollView(
        slivers: <Widget>[
          SliverPadding(
            padding: const EdgeInsets.all(8.0), // Adjust padding if needed
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: gridRatio,
                crossAxisSpacing: 1,
                mainAxisSpacing: 1,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  var vod = videos[index];
                  logger.i('TESTING PLAY RECORD SHORT SCREEN - $vod');
                  return Obx(() => VideoPreviewWithEditWidget(
                      id: vod.id,
                      film: 2,
                      isEditing: listEditorController.isEditing.value,
                      isSelected:
                          listEditorController.selectedIds.contains(vod.id),
                      displayVideoCollectTimes: false,
                      displayVideoTimes: false,
                      displayViewTimes: false,
                      onEditingTap: () {
                        listEditorController.toggleSelected(vod.id);
                      },
                      onOverrideRedirectTap: (id) {
                        MyRouteDelegate.of(context).push(
                          AppRoutes.shortsByLocal,
                          args: {'videoId': vod.id, 'itemId': 0},
                        );
                      },
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
                      videoViewTimes: vod.videoViewTimes ?? 0));
                },
                childCount: videos.length, // the count of the videos
              ),
            ),
          ),
        ],
      );
    });
  }
}
