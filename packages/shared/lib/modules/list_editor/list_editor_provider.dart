// ListEditorProvider is a statefull widget, has only one child of poprs, and will return empty container

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/list_editor_controller.dart';
import '../../enums/list_editor_category.dart';

class ListEditorProvider extends StatefulWidget {
  final ListEditorCategory tag;
  final Widget Function(Function() reset) child;

  const ListEditorProvider({
    Key? key,
    required this.tag,
    required this.child,
  }) : super(key: key);

  @override
  ListEditorProviderState createState() => ListEditorProviderState();
}

class ListEditorProviderState extends State<ListEditorProvider> {
  late final ListEditorController listEditorController;

  @override
  void initState() {
    listEditorController =
        Get.find<ListEditorController>(tag: widget.tag.toString());
    super.initState();
  }

  @override
  void dispose() {
    listEditorController.closeEditing();
    super.dispose();
  }

  void reset() {
    listEditorController.clearSelected();
    listEditorController.closeEditing();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child(reset);
  }
}
