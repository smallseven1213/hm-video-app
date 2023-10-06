import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/event_controller.dart';
import 'package:shared/controllers/list_editor_controller.dart';
import 'package:shared/enums/list_editor_category.dart';

import '../../widgets/list_page_panel.dart';
import 'system_event_card.dart';

class SystemScreen extends StatefulWidget {
  @override
  _SystemScreenState createState() => _SystemScreenState();
}

class _SystemScreenState extends State<SystemScreen> {
  late EventController eventsController;
  final ListEditorController listEditorController =
      Get.find<ListEditorController>(
          tag: ListEditorCategory.notifications.toString());

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
  void initState() {
    super.initState();
    eventsController = Get.put(EventController());
  }

  @override
  void dispose() {
    super.dispose();
    eventsController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('build system screen');
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
                      id: e.id,
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
