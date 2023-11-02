// PanelWidget stateless

import 'package:app_tt/localization/i18n.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/list_editor_controller.dart';

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
    final paddingBottom = MediaQuery.of(context).padding.bottom;
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
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
          height: 77,
          decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFe5e5e5)))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: Obx(() {
                  if (listEditorController.selectedIds.isNotEmpty) {
                    return GestureDetector(
                      onTap: onSelectButtonClick,
                      child: const Row(
                        children: <Widget>[
                          Image(
                            width: 20,
                            height: 20,
                            fit: BoxFit.contain,
                            image: AssetImage('assets/images/check_yes.png'),
                          ),
                          SizedBox(width: 10.0), // Spacing
                          Text('全選',
                              style: TextStyle(
                                  color: Color(0xFF161823), fontSize: 14.0)),
                        ],
                      ),
                    );
                  } else {
                    return GestureDetector(
                      onTap: onSelectButtonClick,
                      child: Row(
                        children: <Widget>[
                          const Image(
                            width: 20,
                            height: 20,
                            fit: BoxFit.contain,
                            image: AssetImage('assets/images/check_no.png'),
                          ),
                          const SizedBox(width: 10.0), // Spacing
                          Text(I18n.selectAll,
                              style: const TextStyle(
                                  color: Color(0xFF161823), fontSize: 14.0)),
                        ],
                      ),
                    );
                  }
                }),
              ),
              GestureDetector(
                onTap: onDeleteButtonClick,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 26.0),
                  decoration: BoxDecoration(
                    color: listEditorController.selectedIds.isNotEmpty
                        ? const Color(0xFFfe2c55)
                        : const Color(0xFFffd0d9),
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                  child: Center(
                      child: Text(
                    I18n.delete,
                    style: const TextStyle(fontSize: 14.0, color: Colors.white),
                  )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
