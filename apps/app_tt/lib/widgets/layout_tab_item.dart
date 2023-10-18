import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/tt_ui_controller.dart';

class LayoutTabItem extends StatelessWidget {
  final bool isActive;
  final String label;
  final VoidCallback onTap;

  const LayoutTabItem({
    Key? key,
    required this.isActive,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TTUIController ttUiController = Get.find<TTUIController>();
    return GestureDetector(
        onTap: onTap,
        child: Obx(() {
          final isDarkMode = ttUiController.isDarkMode.value;
          final bgColor = isDarkMode ? Colors.black : Colors.transparent;
          final fontColor = isDarkMode
              ? isActive
                  ? Colors.white
                  : const Color(0xFF999999)
              : isActive
                  ? Colors.black
                  : const Color(0xFF999999);
          return Container(
            // padding top 16
            padding: const EdgeInsets.only(top: 16),
            color: bgColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: fontColor,
                  ),
                ),
              ],
            ),
          );
        }));
  }
}
