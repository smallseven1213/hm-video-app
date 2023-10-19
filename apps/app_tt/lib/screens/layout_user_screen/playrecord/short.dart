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

const gridRatio = 128 / 227;

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
                                  film: 2, // 來自原始B Code的額外參數
                                  isEditing:
                                      listEditorController.isEditing.value,
                                  isSelected: listEditorController.selectedIds
                                      .contains(video1.id),
                                  onEditingTap: () {
                                    listEditorController
                                        .toggleSelected(video1.id);
                                  },
                                  onOverrideRedirectTap: (id) {
                                    // 來自原始B Code的額外功能
                                    MyRouteDelegate.of(context).push(
                                      AppRoutes.shortsByLocal,
                                      args: {'videoId': video1.id, 'itemId': 1},
                                    );
                                  },
                                  coverVertical: video1.coverVertical ?? '',
                                  coverHorizontal: video1.coverHorizontal ?? '',
                                  timeLength: video1.timeLength ?? 0,
                                  tags: video1.tags ?? [],
                                  title: video1.title,
                                  videoViewTimes: video1.videoViewTimes ??
                                      0, // 替換videoCollectTimes
                                  displayVideoCollectTimes: false,
                                  // 移除不需要的屬性
                                )),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: video2 != null
                                ? Obx(() => VideoPreviewWithEditWidget(
                                      id: video2!.id,
                                      film: 2, // 來自原始B Code的額外參數
                                      isEditing:
                                          listEditorController.isEditing.value,
                                      isSelected: listEditorController
                                          .selectedIds
                                          .contains(video2!.id),
                                      onEditingTap: () {
                                        listEditorController
                                            .toggleSelected(video2!.id);
                                      },
                                      onOverrideRedirectTap: (id) {
                                        // 來自原始B Code的額外功能
                                        MyRouteDelegate.of(context).push(
                                          AppRoutes.shortsByLocal,
                                          args: {
                                            'videoId': video2!.id,
                                            'itemId': 1
                                          },
                                        );
                                      },
                                      coverVertical:
                                          video2!.coverVertical ?? '',
                                      coverHorizontal:
                                          video2!.coverHorizontal ?? '',
                                      timeLength: video2!.timeLength ?? 0,
                                      tags: video2!.tags ?? [],
                                      title: video2!.title,
                                      videoViewTimes: video2!.videoViewTimes ??
                                          0, // 替換videoCollectTimes
                                      displayVideoCollectTimes: false,
                                      // 移除不需要的屬性
                                    ))
                                : const SizedBox(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8), // 替代 separatorBuilder
                    ],
                  );
                },
                // 計算視頻數量，每行兩個
                childCount: (videos.length / 2).ceil(),
              ),
            ),
          ],
        ),
      );
    });
  }
}
