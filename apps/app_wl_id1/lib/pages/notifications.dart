import 'package:app_wl_id1/localization/i18n.dart';
import 'package:app_wl_id1/screens/notifications/notification.dart';
import 'package:app_wl_id1/screens/notifications/system.dart';
import 'package:app_wl_id1/widgets/custom_app_bar.dart';
import 'package:app_wl_id1/widgets/tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/event_controller.dart';
import 'package:shared/controllers/list_editor_controller.dart';
import 'package:shared/enums/list_editor_category.dart';

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
    if (_tabController.index == 1) {
      eventsController.markAllAsRead();
    }
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
        title: I18n.messageCenter,
        bottom: GSTabBar(
            tabs: [I18n.announcement, I18n.systemNotification],
            controller: _tabController),
        actions: [
          _tabController.index == 0
              ? const SizedBox.shrink()
              : Obx(() => TextButton(
                  onPressed: () {
                    listEditorController.toggleEditing();
                  },
                  child: Text(
                    listEditorController.isEditing.value
                        ? I18n.cancel
                        : I18n.editTranslation,
                    style: const TextStyle(color: Color(0xff00B0D4)),
                  ))),
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
  }
}
