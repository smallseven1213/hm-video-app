import 'dart:ui';
import 'package:app_tt/widgets/actor_avatar.dart';
import 'package:flutter/material.dart';

class ActorHeaderInfo extends StatelessWidget {
  final String name;
  final int id;
  final String photoSid;
  final double percentage;
  final double imageSize;

  const ActorHeaderInfo({
    Key? key,
    required this.name,
    required this.id,
    required this.photoSid,
    required this.imageSize,
    required this.percentage,
  }) : super(key: key);

  @override
  @override
  Widget build(BuildContext context) {
    final double fontSize = lerpDouble(21, 15, percentage)!;

    return Row(
      children: [
        ActorAvatar(
          photoSid: photoSid,
          width: imageSize,
          height: imageSize,
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              name,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                  color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }
}
