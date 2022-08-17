import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:wgp_video_h5app/base/v_icon_collection.dart';
import 'package:wgp_video_h5app/components/v_d_icon.dart';

class VDMarquee extends StatefulWidget {
  final double iconWidth;
  final double width;
  final String text;
  const VDMarquee({
    Key? key,
    this.iconWidth = 30,
    this.width = 100,
    required this.text,
  }) : super(key: key);

  @override
  _VDMarqueeState createState() => _VDMarqueeState();
}

class _VDMarqueeState extends State<VDMarquee> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: widget.text.isEmpty
          ? []
          : [
              SizedBox(
                width: widget.iconWidth,
                child: const VDIcon(VIcons.announcement),
              ),
              SizedBox(
                width: widget.width - widget.iconWidth,
                height: 30,
                child: Marquee(
                  key: widget.key,
                  text: widget.text,
                  style: const TextStyle(fontSize: 12),
                  scrollAxis: Axis.horizontal,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  blankSpace: 168.0,
                  // velocity: 50.0,
                  // pauseAfterRound: const Duration(seconds: 1),
                  // showFadingOnlyWhenScrolling: true,
                  // fadingEdgeStartFraction: 0.1,
                  // fadingEdgeEndFraction: 0.1,
                  // numberOfRounds: 3,
                  startPadding: 0.0,
                  // accelerationDuration: const Duration(seconds: 1),
                  // accelerationCurve: Curves.linear,
                  // decelerationDuration: const Duration(milliseconds: 500),
                  // decelerationCurve: Curves.easeOut,
                ),
              )
            ],
    );
  }
}
