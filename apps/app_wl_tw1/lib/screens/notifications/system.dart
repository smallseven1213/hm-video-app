import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/event_controller.dart';
import 'package:shared/controllers/list_editor_controller.dart';
import 'package:shared/enums/list_editor_category.dart';

import '../../localization/i18n.dart';
import '../../widgets/list_page_panel.dart';
import '../../utils/show_confirm_dialog.dart';
import 'system_event_card.dart';

class SystemScreen extends StatelessWidget {
  final EventController eventsController;
  SystemScreen({Key? key, required this.eventsController}) : super(key: key);

  final ListEditorController listEditorController =
      Get.find<ListEditorController>(
          tag: ListEditorCategory.notifications.toString());

  void _handleSelectAll() {
    var allData = eventsController.data;
    listEditorController.saveBoundData(allData.map((e) => e.id).toList());
  }

  void _handleDelete(BuildContext context) {
    var selectedIds = listEditorController.selectedIds.toList();
    showConfirmDialog(
      context: context,
      title: I18n.confirmDelete,
      message: I18n.confirmDeleteSelected,
      onConfirm: () => {
        eventsController.deleteEvents(selectedIds),
        listEditorController.removeBoundData(selectedIds),
      },
    );
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
                      id: e.id,
                    )),
              ],
            )),
        ListPagePanelWidget(
          listEditorController: listEditorController,
          onSelectButtonClick: _handleSelectAll,
          onDeleteButtonClick: () => _handleDelete(context),
        ),
      ],
    );
  }
}
