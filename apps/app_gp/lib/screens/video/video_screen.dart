// VideoScreen stateless

import 'package:app_gp/screens/video/video_player_area.dart';
import 'package:flutter/material.dart';

class VideoScreen extends StatelessWidget {
  final int id;

  VideoScreen({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [VideoPlayerArea(id: id)],
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              title: Text('Video'),
              backgroundColor: Colors.black.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }
}
