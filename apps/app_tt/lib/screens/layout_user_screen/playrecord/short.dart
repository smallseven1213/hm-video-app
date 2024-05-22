import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/list_editor_controller.dart';
import 'package:shared/controllers/play_record_controller.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/enums/list_editor_category.dart';
import 'package:shared/enums/play_record_type.dart';
import 'package:shared/models/index.dart';
import 'package:shared/navigator/delegate.dart';

import '../../../widgets/no_data.dart';
import '../../../widgets/video_preview_with_edit.dart';

const gridRatio = 128 / 173;

final logger = Logger();

class PlayRecordShortScreen extends StatelessWidget {
  PlayRecordShortScreen({Key? key}) : super(key: key);

  final ListEditorController listEditorController =
      Get.find<ListEditorController>(
          tag: ListEditorCategory.playrecord.toString());
  final shortPlayRecordController =
      Get.find<PlayRecordController>(tag: PlayRecordType.short.toString());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var videos = shortPlayRecordController.data;
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
              args: {'videoId': video.id, 'itemId': 1},
            );
          },
          displayVideoFavoriteTimes: false,
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
          videoFavoriteTimes: video.videoFavoriteTimes ?? 0,
          displayVideoTimes: false,
          displayViewTimes: false,
        ));
  }
}
