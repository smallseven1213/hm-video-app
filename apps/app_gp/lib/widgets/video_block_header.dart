import 'package:app_gp/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/color_keys.dart';

class VideoBlockHeader extends StatelessWidget {
  final String text;

  const VideoBlockHeader({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Stack(
        children: [
          Text(
            text,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.colors[ColorKeys.textPrimary],
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(5),
                  right: Radius.circular(5),
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 2.0,
                    color: AppColors.colors[ColorKeys.textPrimary]!
                        .withOpacity(0.5),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
