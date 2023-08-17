// PanelWidget stateless

import 'package:flutter/material.dart';

import 'button.dart';

class ListPagePanelWidget extends StatelessWidget {
  final Function()? onSelectButtonClick;
  final Function()? onDeleteButtonClick;
  final bool isEditing;
  final bool hasSelectedAny;

  const ListPagePanelWidget(
      {Key? key,
      this.onSelectButtonClick,
      this.onDeleteButtonClick,
      required this.isEditing,
      this.hasSelectedAny = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final paddingBottom = MediaQuery.of(context).padding.bottom;
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      bottom: isEditing ? paddingBottom + 0 : paddingBottom - 100,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 25),
        decoration: const BoxDecoration(
          color: Color(0xFF01122D),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                flex: 1,
                child: SizedBox(
                  height: 50,
                  child: Button(
                      text: '全選',
                      type: 'primary',
                      onPressed: onSelectButtonClick!),
                )),
            const SizedBox(width: 10),
            Expanded(
                flex: 1,
                child: SizedBox(
                  height: 50,
                  child: Button(
                      text: '刪除',
                      type: hasSelectedAny ? 'secondary' : 'primary',
                      onPressed: onDeleteButtonClick!),
                )),
          ],
        ),
      ),
    );
  }
}
