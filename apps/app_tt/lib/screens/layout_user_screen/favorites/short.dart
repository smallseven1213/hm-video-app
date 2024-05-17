import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/list_editor_controller.dart';
import 'package:shared/controllers/user_favorites_short_controlle.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/enums/list_editor_category.dart';
import 'package:shared/models/vod.dart';
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
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  List<Vod?> videosInRow = [];
                  for (int i = 0; i < 3; i++) {
                    int videoIndex = index * 3 + i;
                    if (videoIndex < videos.length) {
                      videosInRow.add(videos[videoIndex]);
                    } else {
                      videosInRow.add(null);
                    }
                  }

                  return Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: insertSeparators(
                            videosInRow.map((video) {
                              if (video == null) {
                                return const Expanded(child: SizedBox());
                              }
                              return Expanded(
                                  child: _buildVideoWidget(video, gridRatio,
                                      listEditorController, context));
                            }).toList(),
                            const SizedBox(width: 2)),
                      ),
                      const SizedBox(height: 2),
                    ],
                  );
                },
                childCount: (videos.length / 3).ceil(),
              ),
            )
          ],
        ),
      );
    });
  }

  List<Widget> insertSeparators(List<Widget> widgets, Widget separator) {
    if (widgets.isEmpty) return [];

    List<Widget> withSeparators = [];
    for (int i = 0; i < widgets.length - 1; i++) {
      withSeparators.add(widgets[i]);
      withSeparators.add(separator);
    }
    withSeparators.add(widgets.last);

    return withSeparators;
  }

  Widget _buildVideoWidget(Vod video, double gridRatio,
      ListEditorController listEditorController, BuildContext context) {
    return Obx(() => VideoPreviewWithEditWidget(
          id: video.id,
          film: 2,
          isEditing: listEditorController.isEditing.value,
          isSelected: listEditorController.selectedIds.contains(video.id),
          onEditingTap: () {
            listEditorController.toggleSelected(video.id);
          },
          onOverrideRedirectTap: (id) {
            MyRouteDelegate.of(context).push(
              AppRoutes.shortsByLocal,
              args: {'videoId': video.id, 'itemId': 2},
            );
          },
          displayVideoCollectTimes: false,
          hasRadius: false,
          hasTitle: false,
          hasTags: false,
          imageRatio: gridRatio,
          displayCoverVertical: true,
          coverVertical: video.coverVertical ?? '',
          coverHorizontal: video.coverHorizontal ?? '',
          timeLength: video.timeLength ?? 0,
          tags: video.tags ?? [],
          title: video.title,
          videoViewTimes: video.videoViewTimes ?? 0,
          videoCollectTimes: video.videoCollectTimes ?? 0,
          displayVideoTimes: false,
          displayViewTimes: false,
        ));
  }
}
