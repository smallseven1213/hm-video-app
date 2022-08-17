import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

class VLoading extends StatefulWidget {
  const VLoading({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _VLoadingState();
}

class _VLoadingState extends State<VLoading>
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

    Paint paint_0_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.1250000;
    paint_0_stroke.color = const Color(0xff000000).withOpacity(0.2);
    paint_0_stroke.strokeCap = StrokeCap.round;
    paint_0_stroke.strokeJoin = StrokeJoin.round;
    canvas.drawPath(path_0, paint_0_stroke);

    Path path_1 = Path();
    path_1.moveTo(size.width * 0.06250000, size.height * 0.5000000);
    path_1.lineTo(size.width * 0.2500000, size.height * 0.5000000);
    path_1.lineTo(size.width * 0.3750000, size.height * 0.9166667);
    path_1.lineTo(size.width * 0.6250000, size.height * 0.08333333);
    path_1.lineTo(size.width * 0.7500000, size.height * 0.5000000);
    path_1.lineTo(size.width * 0.9375000, size.height * 0.5000000);

    Paint paint_1_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.1250000;
    paint_1_stroke.color = Color(0xffffdc00).withOpacity(opacity);
    paint_1_stroke.strokeCap = StrokeCap.round;
    paint_1_stroke.strokeJoin = StrokeJoin.round;
    canvas.drawPath(
        dashPath(
          path_1,
          dashArray: CircularIntervalList([12, 36]),
          dashOffset: DashOffset.absolute(offset),
        ),
        paint_1_stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
