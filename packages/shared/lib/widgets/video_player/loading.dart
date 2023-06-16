import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared/widgets/sid_image.dart';

final logger = Logger();

class VideoLoading extends StatelessWidget {
  final String cover;
  const VideoLoading({Key? key, required this.cover}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
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
            key: ValueKey(cover),
            sid: cover,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 16),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }
}
