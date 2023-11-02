import 'package:app_tt/localization/i18n.dart';
import 'package:flutter/material.dart';
import 'package:shared/enums/list_editor_category.dart';
import 'package:shared/modules/list_editor/list_editor_consumer.dart';
import 'package:shared/modules/list_editor/list_editor_toggle_editing_button.dart';

class SubTabBar extends StatelessWidget {
  const SubTabBar({
    Key? key,
    required this.editorTag,
    required this.controller,
    required this.tabs,
    required this.onSelectAll,
  }) : super(key: key);

  final ListEditorCategory editorTag;
  final TabController controller;
  final List<String> tabs;
  final VoidCallback onSelectAll;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      toolbarHeight: 44,
      pinned: true,
      backgroundColor: Colors.white,
      title: Container(
        alignment: Alignment.center,
        color: Colors.white,
        child: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              child: TabBar(
                controller: controller,
                labelPadding: const EdgeInsets.symmetric(horizontal: 5),
                isScrollable: true,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicator:
                    const BoxDecoration(), // Setting a BoxDecoration with no properties will remove the underline
                tabs: tabs
                    .map((e) => Container(
                          height: 24,
                          decoration: BoxDecoration(
                            color: const Color(0xFFf3f3f4),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 22),
                          alignment: Alignment.center,
                          child: Text(e),
                        ))
                    .toList(),
              ),
            ),
            Positioned(
              right: 0,
              child: ListEditorConsumer(
                tag: editorTag,
                child:
                    (isEditing, selectedIds, removeBoundData, saveBoundData) {
                  if (!isEditing) {
                    return ListEditorToggleEditingButton(
                      tag: editorTag,
                      child: Container(
                        width: 44,
                        height: 24,
                        child: const Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: 14,
                            height: 14,
                            child: Image(
                              fit: BoxFit.contain,
                              alignment: Alignment.center,
                              width: 14,
                              height: 14,
                              image: AssetImage(
                                'assets/images/editor.webp',
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return ListEditorToggleEditingButton(
                    tag: editorTag,
                    child: Container(
                      width: 44,
                      height: 24,
                      alignment: Alignment.center,
                      child: Text(I18n.cancel,
                          style: const TextStyle(
                              fontSize: 10, color: Color(0xFFfe2c55))),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
