import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/list_editor_controller.dart';
import 'package:shared/controllers/user_favorites_short_controlle.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/enums/list_editor_category.dart';
import 'package:shared/navigator/delegate.dart';

import '../../../widgets/no_data.dart';
import '../../../widgets/video_preview_with_edit.dart';

const gridRatio = 128 / 227;

class FavoritesShortScreen extends StatelessWidget {
  FavoritesShortScreen({Key? key}) : super(key: key);

  final ListEditorController listEditorController =
      Get.find<ListEditorController>(
          tag: ListEditorCategory.favorites.toString());
  final userFavoritesShortController = Get.find<UserFavoritesShortController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var videos = userFavoritesShortController.data;
      if (videos.isEmpty) {
        return const NoDataWidget();
      }
      return GridView.builder(
        itemCount: userFavoritesShortController.data.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: gridRatio,
          crossAxisSpacing: 1,
          mainAxisSpacing: 1,
        ),
        itemBuilder: (BuildContext context, int index) {
          var vod = userFavoritesShortController.data[index];
          return Obx(() => VideoPreviewWithEditWidget(
              id: vod.id,
              film: 2,
              hasTags: false,
              isEditing: listEditorController.isEditing.value,
              isSelected: listEditorController.selectedIds.contains(vod.id),
              displayVideoFavoriteTimes: false,
              displayVideoTimes: false,
              displayViewTimes: false,
              onEditingTap: () {
                listEditorController.toggleSelected(vod.id);
              },
              onOverrideRedirectTap: (id) {
                MyRouteDelegate.of(context).push(
                  AppRoutes.shortsByLocal,
                  args: {'videoId': vod.id, 'itemId': 2},
                );
              },
              hasRadius: false,
              hasTitle: false,
              imageRatio: gridRatio,
              displayCoverVertical: true,
              coverVertical: vod.coverVertical ?? '',
              coverHorizontal: vod.coverHorizontal ?? '',
              timeLength: vod.timeLength ?? 0,
              tags: vod.tags ?? [],
              title: vod.title,
              videoViewTimes: vod.videoViewTimes!));
        },
      );
    });
  }
}
