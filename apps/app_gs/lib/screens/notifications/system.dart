import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/event_controller.dart';
import 'package:shared/controllers/list_editor_controller.dart';

import '../../widgets/list_page_panel.dart';
import 'system_event_card.dart';

class SystemScreen extends StatelessWidget {
  SystemScreen({Key? key}) : super(key: key);

  final eventsController = Get.put(EventController());
  final ListEditorController listEditorController =
      Get.find<ListEditorController>(tag: 'notifications');

  void _handleSelectAll() {
    var allData = eventsController.data;
    listEditorController.saveBoundData(allData.map((e) => e.id).toList());
  }

  void _handleDeleteAll() {
    var selectedIds = listEditorController.selectedIds.toList();
    eventsController.deleteEvents(selectedIds);
    listEditorController.removeBoundData(selectedIds);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Obx(() => ListView(
              children: [
                ...eventsController.data.map((e) => SystemEventCard(
                      title: e.title,
                      content: e.content,
                      time: e.createdAt,
                      isSelected:
                          listEditorController.selectedIds.contains(e.id),
                      id: e.id!,
                    )),
              ],
            )),
        ListPagePanelWidget(
            listEditorController: listEditorController,
            onSelectButtonClick: _handleSelectAll,
            onDeleteButtonClick: _handleDeleteAll),
      ],
    );
  }
}
