import 'dart:ui';
import 'package:flutter/material.dart';

import 'actor_avatar.dart';

class ActorHeaderInfo extends StatelessWidget {
  final String name;
  final String? aliasName;
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
    this.aliasName,
  }) : super(key: key);

  @override
  @override
  Widget build(BuildContext context) {
    final double fontSize = lerpDouble(21, 15, percentage)!;
    final double fontSize2 = lerpDouble(18, 15, percentage)!;

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 8),
      child: Row(
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
              if (aliasName != null)
                Text(
                  '$aliasName',
                  style: TextStyle(
                    fontSize: fontSize2,
                    color: Colors.white,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
