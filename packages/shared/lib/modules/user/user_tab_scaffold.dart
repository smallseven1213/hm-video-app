import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shared/controllers/list_editor_controller.dart';
import 'package:shared/models/color_keys.dart';

class ListPagePanelWidget extends StatelessWidget {
  final Function()? onSelectButtonClick;
  final Function()? onDeleteButtonClick;
  final ListEditorController listEditorController;
  final Color? overlayColor;
  final Color? primaryButtonBgColor;
  final Color? secondaryButtonBgColor;
  final Color? primaryTextColor;
  final Color? secondaryTextColor;

  const ListPagePanelWidget({
    Key? key,
    this.onSelectButtonClick,
    this.onDeleteButtonClick,
    required this.listEditorController,
    this.overlayColor,
    this.primaryButtonBgColor,
    this.secondaryButtonBgColor,
    this.primaryTextColor,
    this.secondaryTextColor,
  }) : super(key: key);

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
          color: overlayColor,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  flex: 1,
                  child: Container(
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: secondaryButtonBgColor,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: InkWell(
                      onTap: onSelectButtonClick!,
                      child: Text(
                        '全選',
                        style: TextStyle(color: secondaryTextColor),
                      ),
                    ),
                  )),
              const SizedBox(width: 10),
              Expanded(
                  flex: 1,
                  child: Container(
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: primaryButtonBgColor,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: InkWell(
                      onTap: onDeleteButtonClick!,
                      child: Text(
                        '刪除',
                        style: TextStyle(color: primaryTextColor),
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class UserTabScaffold extends StatefulWidget {
  final List<String> tabs;
  final List<Widget> tabViews;
  final VoidCallback onTabChanged;
  final ListEditorController listEditorController;
  final VoidCallback onSelectButtonClick;
  final VoidCallback onDeleteButtonClick;
  final Color? overlayColor;
  final Color? primaryButtonBgColor;
  final Color? secondaryButtonBgColor;
  final Color? primaryTextColor;
  final Color? secondaryTextColor;

  const UserTabScaffold({
    super.key,
    required this.tabs,
    required this.tabViews,
    required this.onTabChanged,
    required this.listEditorController,
    required this.onSelectButtonClick,
    required this.onDeleteButtonClick,
    this.overlayColor,
    this.primaryButtonBgColor,
    this.secondaryButtonBgColor,
    this.primaryTextColor,
    this.secondaryTextColor,
  });

  @override
  UserTabScaffoldState createState() => UserTabScaffoldState();
}

class UserTabScaffoldState extends State<UserTabScaffold>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: widget.tabs.length);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        widget.onTabChanged();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TabBarView(
          controller: _tabController,
          children: widget.tabViews,
        ),
        ListPagePanelWidget(
          listEditorController: widget.listEditorController,
          onSelectButtonClick: widget.onSelectButtonClick,
          onDeleteButtonClick: widget.onDeleteButtonClick,
          overlayColor: widget.overlayColor,
          primaryButtonBgColor: widget.primaryButtonBgColor,
          secondaryButtonBgColor: widget.secondaryButtonBgColor,
          primaryTextColor: widget.primaryTextColor,
          secondaryTextColor: widget.secondaryTextColor,
        ),
      ],
    );
  }
}
