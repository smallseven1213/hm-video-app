import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class OptionButton extends StatelessWidget {
  final bool isSelected;
  final String name;
  final VoidCallback? onTap;

  const OptionButton({
    Key? key,
    required this.isSelected,
    required this.name,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 20,
        color: isSelected ? const Color(0xFFf3f3f4) : Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Center(
            child: Text(
              name,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.black : const Color(0xFF73747b)),
            ),
          ),
        ),
      ),
    );
  }
}
