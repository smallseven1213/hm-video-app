import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/user_order_controller.dart';
import '../../models/user_order.dart';

class UserOrderRecordConsumer extends StatefulWidget {
  final int type;
  final Widget Function(List<Order> records) child;
  const UserOrderRecordConsumer({
    Key? key,
    required this.child,
    required this.type,
  }) : super(key: key);

  @override
  UserOrderRecordConsumerState createState() => UserOrderRecordConsumerState();
}

class UserOrderRecordConsumerState extends State<UserOrderRecordConsumer> {
  late UserOrderController userOrderController;

  @override
  void initState() {
    super.initState();
    userOrderController = Get.put(UserOrderController(type: widget.type),
        tag: 'order-record-${widget.type}');
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => widget.child(userOrderController.orderRecord));
  }
}
