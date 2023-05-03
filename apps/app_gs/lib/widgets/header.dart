import 'package:app_gs/config/colors.dart';
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
    // logger.i('RENDER HEADER');
    return Container(
      // height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final textPainter = TextPainter(
            text: TextSpan(
              text: text,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            textDirection: TextDirection.ltr,
          )..layout(maxWidth: constraints.maxWidth);

          final textWidth = textPainter.width;

          return Row(
            children: [
              Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Positioned(
                    bottom: 2,
                    child: Container(
                      width: textWidth,
                      height: 5,
                      decoration: BoxDecoration(
                        color: AppColors.colors[ColorKeys.textPrimary]!
                            .withOpacity(0.78),
                        borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(5),
                          right: Radius.circular(5),
                        ),
                      ),
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
