import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../controllers/short_video_detail_controller.dart';
import '../../models/vod.dart';
import '../../utils/controller_tag_genarator.dart';

final logger = Logger();

class ShortVideoDataConsumer extends StatefulWidget {
  final int videoId;
  final Widget Function(Vod? video) child;
  final Widget? loading;
  final String tag;

  const ShortVideoDataConsumer({
    Key? key,
    required this.child,
    required this.videoId,
    required this.tag,
    this.loading,
  }) : super(key: key);

  @override
  ShortVideoDataConsumerState createState() => ShortVideoDataConsumerState();
}

class ShortVideoDataConsumerState extends State<ShortVideoDataConsumer> {
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
          controller.video.value,
        ));
  }
}
