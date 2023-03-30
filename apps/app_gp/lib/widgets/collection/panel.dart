// PanelWidget stateless

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/list_editor_controller.dart';
import 'package:shared/controllers/play_record_controller.dart';

import '../button.dart';

class PanelWidget extends StatelessWidget {
  PanelWidget({
    Key? key,
  }) : super(key: key);

  final PlayRecordController playRecordController =
      Get.find<PlayRecordController>();
  final listEditorController =
      Get.find<ListEditorController>(tag: 'playrecord');

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
    return Obx(
      () => listEditorController.isEditing.value
          ? BottomSheet(
              backgroundColor: Colors.black.withOpacity(0.3),
              onClosing: () {},
              builder: (context) {
                return Container(
                  color: Colors.transparent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          flex: 1,
                          child: Button(
                              text: '全選',
                              size: 'small',
                              onPressed: _handleSelectAll)),
                      const SizedBox(width: 10),
                      Expanded(
                          flex: 1,
                          child: Button(
                              text: '刪除',
                              size: 'small',
                              type: 'primary',
                              onPressed: _handleDeleteAll)),
                    ],
                  ),
                );
              },
            )
          : SizedBox.shrink(),
    );
  }
}
