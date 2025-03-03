import 'package:app_wl_tw1/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/color_keys.dart';

class Header extends StatelessWidget {
  final String text;
  final Widget? moreButton;
  final bool? isNormalFontWeight;

  const Header({
    super.key,
    required this.text,
    this.moreButton,
    this.isNormalFontWeight = false,
  });

  @override
  Widget build(BuildContext context) {
    // logger.i('RENDER HEADER');

    if (text == '') return const SizedBox();
    return Container(
      // height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: isNormalFontWeight!
                          ? FontWeight.normal
                          : FontWeight.bold,
                      color: AppColors.colors[ColorKeys.textPrimary],
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  )
                ],
              ),
              const Spacer(),
              moreButton ?? const SizedBox(),
            ],
          );
        },
      ),
    );
  }
}
