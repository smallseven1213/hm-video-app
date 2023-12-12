// create a statelss widget for network image

import 'package:flutter/material.dart';

class NetworkImageWidget extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit? fit;

  const NetworkImageWidget({
    Key? key,
    required this.url,
    this.width,
    this.height,
    this.fit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      width: width ?? double.infinity,
      height: height ?? double.infinity,
      fit: fit ?? BoxFit.cover,
      loadingBuilder: (
        BuildContext context,
        Widget child,
        ImageChunkEvent? loadingProgress,
      ) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) =>
          const Center(child: Icon(Icons.error)),
    );
  }
}
