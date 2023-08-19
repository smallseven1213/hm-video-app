import 'package:flutter/material.dart';
import 'package:shared/navigator/delegate.dart';

class PlayerHeader extends StatelessWidget {
  final String? title;
  final bool isFullscreen;
  final Function toggleFullscreen;

  const PlayerHeader({
    super.key,
    this.title,
    required this.isFullscreen,
    required this.toggleFullscreen,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AppBar(
        title: Text(title ?? '',
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
            )),
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () {
            if (isFullscreen) {
              toggleFullscreen(false);
            } else {
              MyRouteDelegate.of(context).pop();
            }
          },
          child: const Icon(Icons.arrow_back_ios_new, size: 16),
        ),
      ),
    );
  }
}
