import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/list_editor_controller.dart';
import '../../enums/list_editor_category.dart';

class ListEditorResetButton extends StatefulWidget {
  final ListEditorCategory tag;
  final Widget child;

  const ListEditorResetButton({
    Key? key,
    required this.tag,
    required this.child,
  }) : super(key: key);

  @override
  ListEditorResetButtonState createState() => ListEditorResetButtonState();
}

class ListEditorResetButtonState extends State<ListEditorResetButton> {
  late final ListEditorController listEditorController;

  @override
  void initState() {
    listEditorController =
        Get.find<ListEditorController>(tag: widget.tag.toString());
    super.initState();
  }

  void reset() {
    listEditorController.clearSelected();
    listEditorController.isEditing.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => reset(),
      child: widget.child,
    );
  }
}
