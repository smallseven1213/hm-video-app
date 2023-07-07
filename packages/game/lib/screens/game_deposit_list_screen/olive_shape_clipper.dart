import 'package:flutter/material.dart';

class OliveShape extends StatefulWidget {
  final String text;
  final String? type;
  final LinearGradient? bgColor;
  final Color? textColor;
  final double? width;

  const OliveShape({
    Key? key,
    required this.text,
    this.type = 'left', // 'left' or 'right
    this.bgColor =
        const LinearGradient(colors: [Color(0xfffd5900), Color(0xfffd5900)]),
    this.textColor = Colors.white,
    this.width,
  }) : super(key: key);

  @override
  State<OliveShape> createState() => _OliveShapeState();
}

class _OliveShapeState extends State<OliveShape> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: widget.type == 'left'
          ? const BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            )
          : const BorderRadius.only(
              topRight: Radius.circular(10.0), // 右上角圓角半徑
              bottomLeft: Radius.circular(10.0), // 左下角圓角半徑
            ),
      child: Container(
        width: widget.width ?? widget.text.length * 10,
        height: 12,
        decoration: BoxDecoration(gradient: widget.bgColor),
        child: Text(
          widget.text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: widget.textColor,
            fontSize: 10,
          ),
        ),
      ),
    );
  }
}
