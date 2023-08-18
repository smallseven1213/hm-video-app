import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/list_editor_controller.dart';
import '../../enums/list_editor_category.dart';

class ListEditorConsumer extends StatefulWidget {
  final ListEditorCategory tag;
  final Widget Function(
      bool isEditing,
      List<int> selectedIds,
      Function(List<int>) removeBoundData,
      Function(List<int>) saveBoundData) child;

  const ListEditorConsumer({
    Key? key,
    required this.tag,
    required this.child,
  }) : super(key: key);

  @override
  ListEditorConsumerState createState() => ListEditorConsumerState();
}

class ListEditorConsumerState extends State<ListEditorConsumer> {
  late final ListEditorController listEditorController;

  @override
  void initState() {
    listEditorController =
        Get.find<ListEditorController>(tag: widget.tag.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var isEditing = listEditorController.isEditing.value;
      var selectedIds = listEditorController.selectedIds.toList();
      return widget.child(
          isEditing,
          selectedIds,
          listEditorController.removeBoundData,
          listEditorController.saveBoundData);
    });
  }
}
