import 'package:app_gs/widgets/no_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/list_editor_controller.dart';
import 'package:shared/controllers/play_record_controller.dart';

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
            return AlignedGridView.count(
              padding: const EdgeInsets.all(8.0),
              crossAxisCount: 2,
              itemCount: playRecordController.playRecord.length,
              itemBuilder: (BuildContext context, int index) =>
                  VideoPreviewWithEditWidget(
                id: videos[index].id,
                isEditing: listEditorController.isEditing.value,
                isSelected:
                    listEditorController.selectedIds.contains(videos[index].id),
                onEditingTap: () {
                  logger.i('CLICK!!');
                  listEditorController.toggleSelected(videos[index].id);
                },
                title: videos[index].title,
                tags: videos[index].tags,
                timeLength: videos[index].timeLength,
                coverHorizontal: videos[index].coverHorizontal,
                coverVertical: videos[index].coverVertical,
                videoViewTimes: videos[index].videoViewTimes,
                //detail: videos[index].detail,
              ),
              mainAxisSpacing: 12.0,
              crossAxisSpacing: 10.0,
            );
          }),
          ListPagePanelWidget(
              listEditorController: listEditorController,
              onSelectButtonClick: _handleSelectAll,
              onDeleteButtonClick: _handleDeleteAll),
        ],
      ),
    );
  }
}
