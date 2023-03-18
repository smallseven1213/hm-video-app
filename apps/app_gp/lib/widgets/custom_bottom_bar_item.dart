import 'package:flutter/material.dart';
import 'package:shared/widgets/sid_image.dart';

class CustomBottomBarItem extends StatelessWidget {
  final bool isActive;
  final String iconSid;
  final String activeIconSid;
  final String label;
  final VoidCallback onTap;

  const CustomBottomBarItem({
    Key? key,
    required this.isActive,
    required this.iconSid,
    required this.activeIconSid,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logger.i(isActive);
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isActive
              ? SidImage(
                  sid: activeIconSid,
                  width: 30,
                  height: 30,
                )
              : SidImage(
                  sid: iconSid,
                  width: 30,
                  height: 30,
                ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
