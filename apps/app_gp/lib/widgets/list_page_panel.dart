// PanelWidget stateless

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/list_editor_controller.dart';
import 'package:shared/controllers/play_record_controller.dart';

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
                              onPressed: onSelectButtonClick!)),
                      const SizedBox(width: 10),
                      Expanded(
                          flex: 1,
                          child: Button(
                              text: '刪除',
                              size: 'small',
                              type: 'primary',
                              onPressed: onDeleteButtonClick!)),
                    ],
                  ),
                );
              },
            )
          : const SizedBox.shrink(),
    );
  }
}
