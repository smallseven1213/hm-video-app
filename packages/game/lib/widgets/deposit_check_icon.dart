import 'package:flutter/material.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class CustomTriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class CheckIcon extends StatelessWidget {
  const CheckIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 0,
          right: 0,
          child: RotatedBox(
            quarterTurns: 1,
            child: ClipPath(
              clipper: CustomTriangleClipper(),
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: gamePrimaryButtonColor,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10),
                  ),
                ),
              ),
            ),
          ),
        ), // active 右下角打勾icon
        Positioned(
          right: 1,
          bottom: 1,
          child: Icon(
            Icons.check,
            color: gamePrimaryButtonTextColor,
            size: 12,
          ),
        ),
      ],
    );
  }
}
