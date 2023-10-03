import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/redemption_controller.dart';
import '../../models/redemption.dart';

class UserRedemptionConsumer extends StatefulWidget {
  final Widget Function(List<Redemption> records) child;
  const UserRedemptionConsumer({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  UserRedemptionConsumerState createState() => UserRedemptionConsumerState();
}

class UserRedemptionConsumerState extends State<UserRedemptionConsumer> {
  late RedemptionController redemptionController;

  @override
  void initState() {
    super.initState();
    redemptionController =
        Get.put(RedemptionController(), tag: 'redemption-record');
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => widget.child(redemptionController.records));
  }
}
