import 'package:flutter/widgets.dart';

class VideoTitle extends StatelessWidget {
  final String externalId;
  final String title;
  final Color color;

  const VideoTitle({
    super.key,
    required this.externalId,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      externalId != '' ? '$externalId $title' : title,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: color,
      ),
    );
  }
}
