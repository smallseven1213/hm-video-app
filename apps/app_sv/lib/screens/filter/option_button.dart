import 'package:flutter/material.dart';
import 'package:app_sv/config/colors.dart';
import 'package:shared/models/color_keys.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color:
              isSelected ? AppColors.colors[ColorKeys.buttonBgPrimary] : null,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Text(
            name,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected
                  ? AppColors.colors[ColorKeys.buttonTextPrimary]
                  : AppColors.colors[ColorKeys.buttonTextSecondary],
            ),
          ),
        ),
      ),
    );
  }
}
