import 'package:flutter/material.dart';
import 'package:shared/widgets/sid_image.dart';

class VideoCover extends StatelessWidget {
  final String imageSid;
  const VideoCover({super.key, required this.imageSid});

  @override
  Widget build(BuildContext context) {
    return Container(
      foregroundDecoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.8),
            const Color.fromARGB(255, 0, 34, 79),
          ],
          stops: const [0.8, 1.0],
        ),
      ),
      child: SidImage(
        key: ValueKey(imageSid),
        sid: imageSid,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}
