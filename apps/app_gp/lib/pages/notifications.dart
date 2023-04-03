import 'package:app_gp/screens/notifications/notification.dart';
import 'package:app_gp/screens/notifications/system.dart';
import 'package:app_gp/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import '../screens/vendor_videos/list.dart';
import '../widgets/button.dart';
import '../screens/favorites/video.dart';
import '../screens/favorites/actor.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: '消息中心',
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: Button(
                    text: '公告',
                    size: 'small',
                    onPressed: () => _tabController.animateTo(0),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: Button(
                    text: '系統通知',
                    size: 'small',
                    onPressed: () => _tabController.animateTo(1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [NotificationScreen(), SystemScreen()],
      ),
    );
  }
}
