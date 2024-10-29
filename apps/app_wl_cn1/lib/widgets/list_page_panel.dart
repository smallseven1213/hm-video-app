// PanelWidget stateless

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/list_editor_controller.dart';

import '../localization/i18n.dart';
import 'button.dart';

class ListPagePanelWidget extends StatelessWidget {
  final Function()? onSelectButtonClick;
  final Function()? onDeleteButtonClick;
  final ListEditorController listEditorController;

  const ListPagePanelWidget(
      {Key? key,
      this.onSelectButtonClick,
      this.onDeleteButtonClick,
      required this.listEditorController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final paddingBottom = MediaQuery.paddingOf(context).bottom;
    return Obx(
      () => AnimatedPositioned(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        bottom: listEditorController.isEditing.value
            ? paddingBottom + 0
            : paddingBottom - 100,
        left: 0,
        right: 0,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 25),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 50,
                    child: Button(
                        text: I18n.selectAll,
                        type: 'secondary',
                        onPressed: onSelectButtonClick!),
                  )),
              const SizedBox(width: 10),
              Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 50,
                    child: Button(
                      text: I18n.delete,
                      type: listEditorController.selectedIds.isNotEmpty
                          ? 'primary'
                          : 'cancel',
                      onPressed: onDeleteButtonClick!,
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}