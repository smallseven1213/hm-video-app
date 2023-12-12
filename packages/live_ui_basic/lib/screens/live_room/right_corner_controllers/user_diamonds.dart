import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_core/controllers/live_user_controller.dart';

class UserDiamonds extends StatelessWidget {
  const UserDiamonds({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final liveUserDetailController = Get.find<LiveUserController>();
    return Wrap(
      children: [
        IntrinsicWidth(
          child: Container(
            height: 20,
            // 最小寬度是200
            constraints: const BoxConstraints(minWidth: 100),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Color(0xbdf771b5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'packages/live_ui_basic/assets/images/rank_diamond.webp',
                  width: 16,
                  height: 16,
                ),
                const SizedBox(width: 2),
                Obx(() => Expanded(
                      child: Text(
                        liveUserDetailController.userDetail.value?.wallet
                                .toString() ??
                            '0',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    )),
                const SizedBox(width: 2),
                Image.asset(
                  'packages/live_ui_basic/assets/images/amount_add.webp',
                  width: 8,
                  height: 8,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
