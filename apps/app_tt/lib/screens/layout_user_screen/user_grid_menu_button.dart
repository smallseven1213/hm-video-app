import 'package:flutter/material.dart';

class UserGridMenuButton extends StatelessWidget {
  const UserGridMenuButton({
    Key? key,
    required this.iconWidget,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  final Widget iconWidget;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 38,
            width: 38,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color(0xfff3f3f4),
            ),
            child: Center(
              child: SizedBox(
                height: 18,
                width: 18,
                child: iconWidget,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(text,
              style: const TextStyle(color: Color(0xFF2e3039), fontSize: 12)),
        ],
      ),
    );
  }
}
