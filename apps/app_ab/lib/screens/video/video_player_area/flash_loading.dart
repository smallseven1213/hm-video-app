import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

class FlashLoading extends StatefulWidget {
  const FlashLoading({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FlashLoadingState();
}

class _FlashLoadingState extends State<FlashLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..addListener(() {
            setState(() {});
          })
          ..repeat();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(20, 20),
      painter: RPSCustomPainter(
        opacity: (1 - _animationController.value).abs(),
        offset: -64 * (1 - _animationController.value).abs(),
      ),
    );
  }
}

class RPSCustomPainter extends CustomPainter {
  final double opacity;
  final double offset;

  RPSCustomPainter({this.opacity = 1.0, this.offset = 0.0});

  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.06250000, size.height * 0.5000000);
    path_0.lineTo(size.width * 0.2500000, size.height * 0.5000000);
    path_0.lineTo(size.width * 0.3750000, size.height * 0.9166667);
    path_0.lineTo(size.width * 0.6250000, size.height * 0.08333333);
    path_0.lineTo(size.width * 0.7500000, size.height * 0.5000000);
    path_0.lineTo(size.width * 0.9375000, size.height * 0.5000000);

    Paint paint0Stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.1250000;
    paint0Stroke.color = const Color(0xffefefef).withOpacity(0.3);
    paint0Stroke.strokeCap = StrokeCap.round;
    paint0Stroke.strokeJoin = StrokeJoin.round;
    canvas.drawPath(path_0, paint0Stroke);

    Path path_1 = Path();
    path_1.moveTo(size.width * 0.06250000, size.height * 0.5000000);
    path_1.lineTo(size.width * 0.2500000, size.height * 0.5000000);
    path_1.lineTo(size.width * 0.3750000, size.height * 0.9166667);
    path_1.lineTo(size.width * 0.6250000, size.height * 0.08333333);
    path_1.lineTo(size.width * 0.7500000, size.height * 0.5000000);
    path_1.lineTo(size.width * 0.9375000, size.height * 0.5000000);

    Paint paint1Stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.1250000;
    paint1Stroke.color = const Color(0XFFF4CDCA).withOpacity(opacity);
    paint1Stroke.strokeCap = StrokeCap.round;
    paint1Stroke.strokeJoin = StrokeJoin.round;
    canvas.drawPath(
        dashPath(
          path_1,
          dashArray: CircularIntervalList([12, 36]),
          dashOffset: DashOffset.absolute(offset),
        ),
        paint1Stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
