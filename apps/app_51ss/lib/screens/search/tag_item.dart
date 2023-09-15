import 'package:flutter/material.dart';
import 'package:shared/models/color_keys.dart';

import '../../config/colors.dart';

class TagItem extends StatelessWidget {
  final VoidCallback onTap;
  final String tag;

  const TagItem({Key? key, required this.tag, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.colors[ColorKeys.buttonBgSecondary],
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          tag,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.colors[ColorKeys.buttonTextSecondary],
          ),
        ),
      ),
    );
  }
}
