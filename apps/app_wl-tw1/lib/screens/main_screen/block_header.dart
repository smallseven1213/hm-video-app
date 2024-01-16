import 'package:flutter/material.dart';
import 'package:shared/models/color_keys.dart';

import '../../config/colors.dart';

class BlockHeader extends StatelessWidget {
  final String text;
  final Widget? moreButton;

  const BlockHeader({Key? key, required this.text, this.moreButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (text == "") {
      return Container();
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  height: 8,
                  width: 2,
                  color: AppColors.colors[ColorKeys.secondary],
                ),
                const SizedBox(width: 8),
                Text(
                  text,
                  style: TextStyle(
                    color: AppColors.colors[ColorKeys.textPrimary],
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            moreButton ?? Container(),
          ],
        ),
      );
    }
  }
}
