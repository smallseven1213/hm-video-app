import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/list_editor_controller.dart';
import '../../enums/list_editor_category.dart';

class ListEditorToggleEditingButton extends StatefulWidget {
  final ListEditorCategory tag;
  final Widget child;

  const ListEditorToggleEditingButton({
    Key? key,
    required this.tag,
    required this.child,
  }) : super(key: key);

  @override
  ListEditorToggleEditingButtonState createState() =>
      ListEditorToggleEditingButtonState();
}

class ListEditorToggleEditingButtonState
    extends State<ListEditorToggleEditingButton> {
  late final ListEditorController listEditorController;

  @override
  void initState() {
    listEditorController =
        Get.find<ListEditorController>(tag: widget.tag.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => listEditorController.toggleEditing(),
      child: widget.child,
    );
  }
}
