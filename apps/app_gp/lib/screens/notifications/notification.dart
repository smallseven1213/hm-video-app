import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/notice_announcement_controller.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({Key? key}) : super(key: key);

  final announcementController = Get.put(NoticeAnnouncementController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => ListView(
          children: [
            ...announcementController.announcement.map((e) => ExpansionTile(
                  title: Row(
                    children: [
                      Icon(Icons.arrow_downward),
                      SizedBox(width: 8),
                      Text(e.title),
                    ],
                  ),
                  children: [
                    ListTile(
                      title: Text(e.content!),
                    ),
                  ],
                )),
          ],
        ));
  }
}
