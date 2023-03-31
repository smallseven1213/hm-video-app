import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/list_editor_controller.dart';
import 'package:shared/controllers/play_record_controller.dart';

import '../widgets/custom_app_bar.dart';
import '../widgets/list_page_panel.dart';
import '../widgets/video_preview.dart';

class PlayRecordPage extends StatefulWidget {
  PlayRecordPage({Key? key}) : super(key: key);

  @override
  _PlayRecordPageState createState() => _PlayRecordPageState();
}

class _PlayRecordPageState extends State<PlayRecordPage> {
  final PlayRecordController playRecordController =
      Get.find<PlayRecordController>();
  final ListEditorController listEditorController =
      Get.find<ListEditorController>(tag: 'playrecord');

  @override
  void dispose() {
    listEditorController.clearSelected();
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
            return AlignedGridView.count(
              padding: const EdgeInsets.all(8.0),
              crossAxisCount: 2,
              itemCount: playRecordController.playRecord.length,
              itemBuilder: (BuildContext context, int index) =>
                  Obx(() => VideoPreviewWidget(
                        id: videos[index].detail?.id ?? videos[index].id,
                        isEditing: listEditorController.isEditing.value,
                        isSelected: listEditorController.selectedIds
                            .contains(videos[index].id),
                        onEditingTap: () {
                          listEditorController.toggleSelected(videos[index].id);
                        },
                        title: videos[index].title,
                        tags: videos[index].tags,
                        timeLength: videos[index].timeLength,
                        coverHorizontal: videos[index].coverHorizontal,
                        coverVertical: videos[index].coverVertical,
                        videoViewTimes: videos[index].videoViewTimes,
                        detail: videos[index].detail,
                      )),
              mainAxisSpacing: 12.0,
              crossAxisSpacing: 10.0,
            );
          }),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ListPagePanelWidget(
                listEditorController: listEditorController,
                onSelectButtonClick: _handleSelectAll,
                onDeleteButtonClick: _handleDeleteAll),
          ),
        ],
      ),
    );
  }
}
