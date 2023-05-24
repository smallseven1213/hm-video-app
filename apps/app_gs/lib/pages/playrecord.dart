import 'package:app_gs/widgets/no_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/list_editor_controller.dart';
import 'package:shared/controllers/play_record_controller.dart';
import 'package:shared/models/video_database_field.dart';

import '../widgets/custom_app_bar.dart';
import '../widgets/list_page_panel.dart';
import '../widgets/video_preview_with_edit.dart';

final logger = Logger();

class PlayRecordPage extends StatefulWidget {
  const PlayRecordPage({Key? key}) : super(key: key);

  @override
  PlayRecordPageState createState() => PlayRecordPageState();
}

class PlayRecordPageState extends State<PlayRecordPage> {
  final PlayRecordController playRecordController =
      Get.find<PlayRecordController>();
  final ListEditorController listEditorController =
      Get.find<ListEditorController>(tag: 'playrecord');

  @override
  void dispose() {
    listEditorController.closeEditing();
    super.dispose();
  }

  void _handleSelectAll() {
    var allData = playRecordController.playRecord;
    listEditorController.saveBoundData(allData.map((e) => e.id).toList());
  }

  void _handleDeleteAll() {
    var selectedIds = listEditorController.selectedIds.toList();
    playRecordController.removePlayRecord(selectedIds);
    listEditorController.removeBoundData(selectedIds);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: '我的足跡',
        actions: [
          Obx(() => TextButton(
              onPressed: () {
                listEditorController.toggleEditing();
              },
              child: Text(
                listEditorController.isEditing.value ? '取消' : '編輯',
                style: const TextStyle(color: Color(0xff00B0D4)),
              )))
        ],
      ),
      body: Stack(
        children: [
          Obx(() {
            var videos = playRecordController.playRecord;
            if (videos.isEmpty) {
              return const NoDataWidget();
            }
            return ListView.separated(
              padding: const EdgeInsets.all(8.0),
              itemCount: (videos.length / 2).ceil(),
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: 8);
              },
              itemBuilder: (BuildContext context, int index) {
                logger.i('RENDER BOX Testing');
                var video1 = videos[index * 2];
                VideoDatabaseField? video2;
                if (index * 2 + 1 < videos.length) {
                  video2 = videos[index * 2 + 1];
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: VideoPreviewWithEditWidget(
                        id: video1.id,
                        isEditing: listEditorController.isEditing.value,
                        isSelected: listEditorController.selectedIds
                            .contains(video1.id),
                        onEditingTap: () {
                          listEditorController.toggleSelected(video1.id);
                        },
                        title: video1.title,
                        tags: video1.tags,
                        timeLength: video1.timeLength,
                        coverHorizontal: video1.coverHorizontal,
                        coverVertical: video1.coverVertical,
                        videoViewTimes: video1.videoViewTimes,
                        // detail: video1.detail,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: video2 != null
                          ? VideoPreviewWithEditWidget(
                              id: video2.id,
                              isEditing: listEditorController.isEditing.value,
                              isSelected: listEditorController.selectedIds
                                  .contains(video2.id),
                              onEditingTap: () {
                                listEditorController.toggleSelected(video2!.id);
                              },
                              title: video2.title,
                              tags: video2.tags,
                              timeLength: video2.timeLength,
                              coverHorizontal: video2.coverHorizontal,
                              coverVertical: video2.coverVertical,
                              videoViewTimes: video2.videoViewTimes,
                              // detail: video2.detail,
                            )
                          : const SizedBox(),
                    ),
                  ],
                );
              },
            );
          }),
          ListPagePanelWidget(
            listEditorController: listEditorController,
            onSelectButtonClick: _handleSelectAll,
            onDeleteButtonClick: _handleDeleteAll,
          ),
        ],
      ),
    );
  }
}
