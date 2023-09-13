import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/user_privilege_controller.dart';
import '../../models/product.dart';
import '../../models/user_privilege_record.dart';

enum ProductType {
  none,
  coin,
  vip,
}

class UserPrivilegeRecordConsumer extends StatefulWidget {
  final String userId;
  final Widget Function(List<UserPrivilegeRecord> product) child;
  const UserPrivilegeRecordConsumer({
    Key? key,
    required this.child,
    required this.userId,
  }) : super(key: key);

  @override
  ProductPageState createState() => ProductPageState();
}

class ProductPageState extends State<UserPrivilegeRecordConsumer> {
  late UserPrivilegeController userPrivilegeController;

  @override
  void initState() {
    super.initState();
    userPrivilegeController = Get.put(
        UserPrivilegeController(userId: widget.userId),
        tag: 'privilege-record-${widget.userId}');
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => widget.child(userPrivilegeController.privilegeRecord));
  }
}
