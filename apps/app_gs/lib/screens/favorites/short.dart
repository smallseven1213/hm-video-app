import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/list_editor_controller.dart';
import 'package:shared/controllers/user_favorites_short_controlle.dart';
import 'package:shared/models/video_database_field.dart';

import '../../widgets/no_data.dart';
import '../../widgets/video_preview_with_edit.dart';

const gridRatio = 128 / 227;

class FavoritesShortScreen extends StatelessWidget {
  FavoritesShortScreen({Key? key}) : super(key: key);

  final ListEditorController listEditorController =
      Get.find<ListEditorController>(tag: 'favorites');
  final userFavoritesShortController = Get.find<UserFavoritesShortController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var videos = userFavoritesShortController.videos;
      if (videos.isEmpty) {
        return const NoDataWidget();
      }
      return GridView.builder(
        itemCount: userFavoritesShortController.videos.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: gridRatio,
          crossAxisSpacing: 1,
          mainAxisSpacing: 1,
        ),
        itemBuilder: (BuildContext context, int index) {
          var vod = userFavoritesShortController.videos.value[index];
          return VideoPreviewWithEditWidget(
              id: vod.id,
              film: 2,
              // onOverrideRedirectTap: () {
              //   MyRouteDelegate.of(context).push(
              //     AppRoutes.shortsByTag.value,
              //     args: {'videoId': vod.id, 'tagId': tagId},
              //     removeSamePath: true,
              //   );
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
