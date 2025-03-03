import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/user_purchase_record_controller.dart';
import '../../models/user_purchase_record.dart';

class UserPurchaseRecordConsumer extends StatefulWidget {
  final String userId;
  final Widget Function(List<UserPurchaseRecord> records) child;
  const UserPurchaseRecordConsumer({
    Key? key,
    required this.child,
    required this.userId,
  }) : super(key: key);

  @override
  UserPurchaseRecordConsumerState createState() =>
      UserPurchaseRecordConsumerState();
}

class UserPurchaseRecordConsumerState
    extends State<UserPurchaseRecordConsumer> {
  late UserPurchaseRecordController userPurchaseRecordController;

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<UserPurchaseRecordController>()) {
      Get.put(UserPurchaseRecordController(),
          tag: 'point-record-${widget.userId}');
    }
    userPurchaseRecordController = Get.find<UserPurchaseRecordController>(
        tag: 'point-record-${widget.userId}');
    userPurchaseRecordController.initCollection(userId: widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => widget.child(userPurchaseRecordController.pointRecord));
  }
}
