import 'package:app_gs/screens/notifications/notification.dart';
import 'package:app_gs/screens/notifications/system.dart';
import 'package:app_gs/widgets/custom_app_bar.dart';
import 'package:app_gs/widgets/tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/list_editor_controller.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  NotificationsPageState createState() => NotificationsPageState();
}

class NotificationsPageState extends State<NotificationsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final ListEditorController listEditorController =
      Get.find<ListEditorController>(tag: 'notifications');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    listEditorController.clearSelected();
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: '消息中心',
        bottom:
            GSTabBar(tabs: const ['公告', '系統通知'], controller: _tabController),
        actions: [
          _tabController.index == 0
              ? const SizedBox.shrink()
              : Obx(() => TextButton(
                  onPressed: () {
                    listEditorController.toggleEditing();
                  },
                  child: Text(
                    listEditorController.isEditing.value ? '取消' : '編輯',
                    style: const TextStyle(color: Color(0xff00B0D4)),
                  ))),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [NotificationScreen(), SystemScreen()],
      ),
    );
  }
}
