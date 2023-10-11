import 'package:app_ra/widgets/my_app_bar.dart';
import 'package:app_ra/widgets/ra_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/event_controller.dart';
import 'package:shared/controllers/list_editor_controller.dart';
import 'package:shared/enums/list_editor_category.dart';

import '../screens/notifications/notification.dart';
import '../screens/notifications/system.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  NotificationsPageState createState() => NotificationsPageState();
}

class NotificationsPageState extends State<NotificationsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final eventsController = Get.find<EventController>();

  final ListEditorController listEditorController =
      Get.find<ListEditorController>(
          tag: ListEditorCategory.notifications.toString());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _tabController.addListener(_handleTabSelection);
    eventsController.fetchData();
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
    return Obx(() {
      bool hasUnRead =
          eventsController.data.any((element) => element.isRead == false);
      return Scaffold(
        appBar: MyAppBar(
          title: '消息中心',
          bottom: RATabBar(
            tabs: const ['公告', '系統通知'],
            dotIndexes: hasUnRead ? [1] : [],
            controller: _tabController,
          ),
          actions: [
            _tabController.index == 0
                ? const SizedBox.shrink()
                : TextButton(
                    onPressed: () {
                      listEditorController.toggleEditing();
                    },
                    child: Text(
                      listEditorController.isEditing.value ? '取消' : '編輯',
                      style: const TextStyle(
                        color: Color(0xffFDDCEF),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    )),
          ],
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            NotificationScreen(),
            SystemScreen(eventsController: eventsController)
          ],
        ),
      );
    });
  }
}
