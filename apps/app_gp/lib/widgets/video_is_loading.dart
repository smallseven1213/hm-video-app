import 'package:flutter/material.dart';

class VideoListLoading extends StatelessWidget {
  final bool isLoading;
  const VideoListLoading({Key? key, this.isLoading = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: Text('讀取中'),
          )
        : const SizedBox();
  }
}
