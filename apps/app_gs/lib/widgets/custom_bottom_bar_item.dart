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
    return InkWell(
        onTap: onTap,
        child: Container(
          color: Color(0xFF001a3e),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isActive
                  ? SidImage(
                      key: const Key('activeIcon'),
                      sid: activeIconSid,
                      width: 30,
                      height: 30,
                      noFadeIn: true,
                    )
                  : SidImage(
                      key: const Key('unactiveIcon'),
                      sid: iconSid,
                      width: 30,
                      height: 30,
                      noFadeIn: true,
                    ),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ));
  }
}
