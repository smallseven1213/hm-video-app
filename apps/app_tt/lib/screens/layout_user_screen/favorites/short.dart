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
      return Padding(
        padding: const EdgeInsets.only(top: 10.0, right: 8, left: 8),
        child: CustomScrollView(
          physics: const NeverScrollableScrollPhysics(),
          controller: PrimaryScrollController.of(context),
          slivers: <Widget>[
            SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: gridRatio,
                crossAxisSpacing: 1,
                mainAxisSpacing: 1,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  var vod = videos[index];
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
                childCount: videos.length, // 这里需要指定子元素的数量
              ),
            ),
          ],
        ),
      );
    });
  }
}
