import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../controllers/short_video_detail_controller.dart';

final logger = Logger();

class ShortVideoPlayUrlConsumer extends StatefulWidget {
  final int videoId;
  final String tag;
  final Widget Function(String? playUrl) child;
  final Widget? loading;

  const ShortVideoPlayUrlConsumer({
    Key? key,
    required this.child,
    required this.videoId,
    required this.tag,
    this.loading,
  }) : super(key: key);

  @override
  ShortVideoPlayUrlConsumerState createState() =>
      ShortVideoPlayUrlConsumerState();
}

class ShortVideoPlayUrlConsumerState extends State<ShortVideoPlayUrlConsumer> {
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
          controller.videoUrl.value,
        ));
  }
}
