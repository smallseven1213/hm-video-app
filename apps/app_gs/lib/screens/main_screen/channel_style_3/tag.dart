import 'package:flutter/material.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/widgets/sid_image.dart';

class TagWidget extends StatelessWidget {
  final int id;
  final String name;
  final bool outerFrame;
  final String? photoSid;
  final int film;
  final int channelId;

  const TagWidget({
    super.key,
    required this.id,
    required this.name,
    required this.outerFrame,
    required this.film,
    required this.channelId,
    this.photoSid,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        MyRouteDelegate.of(context).push(
          AppRoutes.videoByBlock,
          args: {
            'blockId': id,
            'title': '#$name',
            'channelId': channelId,
            'film': film,
          },
        );
      },
      child: Container(
        height: 35,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CustomPaint(
            painter: outerFrame == true ? _GradientBorderPainter() : null,
            child: Stack(
              children: [
                photoSid != null && outerFrame == false
                    ? SidImage(sid: photoSid!)
                    : Container(),
                outerFrame == false
                    ? Container(
                        width: 100, // 你可以根据需要设置宽度
                        height: 100, // 你可以根据需要设置高度
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(
                              0, 0, 0, 0.7), // 设置背景颜色为半透明的黑色
                          borderRadius:
                              BorderRadius.circular(10), // 如果需要圆角，你可以设置这个属性
                        ),
                      )
                    : Container(),
                Center(
                  child: Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GradientBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    const Gradient gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFF00b2ff),
        Color(0xFFcceaff),
        Color(0xFF0075ff),
      ],
    );
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..shader = gradient.createShader(rect);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(10.0)),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
