import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_core/controllers/live_user_controller.dart';

import '../localization/live_localization_delegate.dart';

class PaymentCheckbox extends StatelessWidget {
  const PaymentCheckbox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final liveUserController = Get.find<LiveUserController>();
    final LiveLocalizations localizations = LiveLocalizations.of(context)!;

    return InkWell(
      onTap: () {
        liveUserController.setAutoRenew(!liveUserController.isAutoRenew.value);
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(() => Container(
                width: 24, // Adjust the size to fit your design
                height: 24, // Adjust the size to fit your design
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  liveUserController.isAutoRenew.value
                      ? 'packages/live_ui_basic/assets/images/payment_is_check.webp'
                      : 'packages/live_ui_basic/assets/images/payment_is_not_check.webp',
                  fit: BoxFit.cover,
                ),
              )),
          const SizedBox(width: 8), // Spacing between the icon and the text
          Text(
            localizations.translate('auto_renewal'),
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white, // Change the color to match your design
            ),
          ),
        ],
      ),
    );
  }
}
