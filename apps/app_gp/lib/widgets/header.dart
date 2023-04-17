import 'package:app_gp/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/navigator/delegate.dart';

class Header extends StatelessWidget {
  final String text;
  final Widget? moreButton;

  const Header({
    super.key,
    required this.text,
    this.moreButton,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final textPainter = TextPainter(
            text: TextSpan(
              text: text,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            textDirection: TextDirection.ltr,
          )..layout(maxWidth: constraints.maxWidth);

          final textWidth = textPainter.width;

          return Row(
            children: [
              Column(
                children: [
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    width: textWidth,
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
                          spreadRadius: 2.0,
                          color: AppColors.colors[ColorKeys.textPrimary]!
                              .withOpacity(0.5),
                        ),
                      ],
                    ),
                  ),
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
