import 'package:flutter/material.dart';

class VideoTitleWidget extends StatelessWidget {
  final String title;

  const VideoTitleWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          color: Color(0xffe6e6e6),
          shadows: [
            Shadow(
              offset: Offset(0, 2), // Horizontal and Vertical offset
              blurRadius: 4.0, // Amount of blur
              color:
                  Color.fromARGB(128, 0, 0, 0), // Color with 50% (0.5) opacity
            ),
          ],
        ),
      ),
    );
  }
}
