// VideoScreen stateless

import 'package:app_gp/screens/video/video_player_area.dart';
import 'package:flutter/material.dart';

class VideoScreen extends StatelessWidget {
  final int id;
  final String? name;

  const VideoScreen({
    Key? key,
    required this.id,
    this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            CustomScrollView(
              slivers: [VideoPlayerArea(id: id, name: name)],
            ),
          ],
        ),
      ),
    );
  }
}
