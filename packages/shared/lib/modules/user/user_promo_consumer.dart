import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/models/user_promote.dart';
import 'package:shared/controllers/user_promo_controller.dart';

class UserPromoConsumer extends StatelessWidget {
  final Widget Function(UserPromote promoteData) child;
  const UserPromoConsumer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userPromoController = Get.find<UserPromoController>();
    var promoteData = userPromoController.promoteData.value;
    print('promoteData, $promoteData');
    return Obx(() => child(promoteData));
  }
}
