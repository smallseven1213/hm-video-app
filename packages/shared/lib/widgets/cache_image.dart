import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/widgets/cache_image_web.dart';

class CacheImage extends StatelessWidget {
  final String url;
  final double width;
  final double height;
  final BoxFit fit;
  final String emptyImageUrl;

  const CacheImage({
    Key? key,
    required this.url,
    this.width = double.infinity,
    this.height = double.infinity,
    this.fit = BoxFit.cover,
    this.emptyImageUrl =
        'packages/game/assets/images/game_lobby/game_empty-dark.webp',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (GetPlatform.isWeb) {
      return CacheImageWeb(
        url: url,
        width: width,
        height: height,
        fit: fit,
        emptyImageUrl: emptyImageUrl,
      );
    } else {
      return CachedNetworkImage(
        imageUrl: url,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(),
        ),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      );
    }
  }
}
