import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../controllers/short_video_detail_controller.dart';

final logger = Logger();

class ShortVideoFavoriteCountConsumer extends StatefulWidget {
  final int videoId;
  final String tag;
  final Widget Function(int favoriteCount, Function(int) update) child;

  const ShortVideoFavoriteCountConsumer({
    Key? key,
    required this.child,
    required this.videoId,
    required this.tag,
  }) : super(key: key);

  @override
  ShortVideoFavoriteCountConsumerState createState() =>
      ShortVideoFavoriteCountConsumerState();
}

class ShortVideoFavoriteCountConsumerState
    extends State<ShortVideoFavoriteCountConsumer> {
  late final ShortVideoDetailController controller;

  @override
  void initState() {
    super.initState();

    try {
      controller = Get.find<ShortVideoDetailController>(tag: widget.tag);
    } catch (e) {
      logger.e(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => widget.child(
          controller.videoFavorites.value,
          controller.updateFavorites,
        ));
  }
}
