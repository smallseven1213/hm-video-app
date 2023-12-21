import 'package:flutter/material.dart';

enum ButtonType { primary, secondary }

class LiveButton extends StatelessWidget {
  final String text;
  final ButtonType type;
  final VoidCallback onTap;

  const LiveButton({
    Key? key,
    required this.text,
    required this.type,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        foregroundColor:
            type == ButtonType.primary ? Colors.white : const Color(0xFF7B7B7B),
        backgroundColor: type == ButtonType.primary
            ? const Color(0xFFAE57FF)
            : const Color(0xFF2F364F),
        textStyle: TextStyle(
          fontSize: 12,
          fontWeight:
              type == ButtonType.primary ? FontWeight.bold : FontWeight.normal,
        ),
        fixedSize: const Size.fromHeight(33),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(text),
    );
  }
}
