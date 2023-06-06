import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class Marquee extends StatefulWidget {
  final double iconWidth;
  final double width;
  final String text;
  final TextStyle? style;
  final Icon? icon;

  const Marquee({
    Key? key,
    this.iconWidth = 30,
    this.width = 100,
    this.style,
    this.icon,
    required this.text,
  }) : super(key: key);

  @override
  MarqueeState createState() => MarqueeState();
}

class MarqueeState extends State<Marquee> {
  @override
  Widget build(BuildContext context) {
    logger.i('text: ${widget.text}');
    return Row(
      children: widget.text.isEmpty
          ? []
          : [
              SizedBox(
                width: widget.iconWidth,
                child: const Icon(
                  Icons.arrow_right,
                  size: 20,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: widget.width - widget.iconWidth,
                height: 30,
                child: Marquee(
                  key: widget.key,
                  text: widget.text,
                  style: widget.style ?? const TextStyle(fontSize: 12),
                ),
              )
            ],
    );
  }
}
