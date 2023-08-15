import 'package:flutter/material.dart';
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
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      bottom: listEditorController.isEditing.value
          ? paddingBottom + 0
          : paddingBottom - 100,
      left: 0,
      right: 0,
      child: Container(
        color: Colors.red,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                flex: 1,
                child: SizedBox(
                  height: 50,
                  child: InkWell(onTap: onSelectButtonClick!),
                )),
            const SizedBox(width: 10),
            Expanded(
                flex: 1,
                child: SizedBox(
                  height: 50,
                  child: InkWell(onTap: onDeleteButtonClick!),
                )),
          ],
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

  const UserTabScaffold({
    super.key,
    required this.tabs,
    required this.tabViews,
    required this.onTabChanged,
    required this.listEditorController,
    required this.onSelectButtonClick,
    required this.onDeleteButtonClick,
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
        ),
      ],
    );
  }
}
