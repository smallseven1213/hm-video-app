import 'package:app_ra/config/colors.dart';
import 'package:flutter/material.dart';
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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: isSelected
              ? Border.all(
                  color: AppColors.colors[ColorKeys.primary]!, width: 2)
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          child: Center(
            child: Text(
              name,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.colors[ColorKeys.primary]!,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
