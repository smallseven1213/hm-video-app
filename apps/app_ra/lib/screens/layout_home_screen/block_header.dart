// BlockHeader is a stateless widget, return empty container

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
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 1),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 4,
                    color: AppColors.colors[ColorKeys.textPrimary]!,
                  ),
                ),
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: AppColors.colors[ColorKeys.textPrimary]!,
                  fontSize: 20,
                ),
              ),
            ),
            moreButton ?? Container(),
          ],
        ),
      );
    }
  }
}
