import 'package:flutter/material.dart';

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
    return GestureDetector(
        onTap: onTap,
        child: Container(
          // padding top 16
          padding: const EdgeInsets.only(top: 16),
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: isActive ? Colors.black : const Color(0xFF999999)),
              ),
            ],
          ),
        ));
  }
}
