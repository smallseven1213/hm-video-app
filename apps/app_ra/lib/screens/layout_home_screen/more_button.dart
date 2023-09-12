import 'package:app_ra/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/color_keys.dart';

class MoreButton extends StatelessWidget {
  final VoidCallback? onTap;

  const MoreButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Text('更多', style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(width: 5),
          Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: AppColors.colors[ColorKeys.textPrimary]!,
          ),
        ],
      ),
    );
  }
}
