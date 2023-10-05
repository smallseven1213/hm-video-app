import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/notice_announcement_controller.dart';

import 'notification_item.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({Key? key}) : super(key: key);

  final announcementController = Get.put(NoticeAnnouncementController());

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Obx(() => ListView(
              children: [
                ...announcementController.announcement
                    .map((e) => NotificationItem(
                          title: e.title,
                          content: e.content ?? '',
                          startedAt: e.startedAt,
                        )),
              ],
            )));
  }
}
