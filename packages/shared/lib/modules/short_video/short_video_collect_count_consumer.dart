import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../controllers/short_video_detail_controller.dart';
import '../../utils/controller_tag_genarator.dart';

final logger = Logger();

class ShortVideoCollectCountConsumer extends StatefulWidget {
  final int videoId;
  final Widget Function(int collectCount, Function(int) update) child;

  const ShortVideoCollectCountConsumer({
    Key? key,
    required this.child,
    required this.videoId,
  }) : super(key: key);

  @override
  ShortVideoCollectCountConsumerState createState() =>
      ShortVideoCollectCountConsumerState();
}

class ShortVideoCollectCountConsumerState
    extends State<ShortVideoCollectCountConsumer> {
  late final String controllerTag;
  late final ShortVideoDetailController controller;

  @override
  void initState() {
    super.initState();

    controllerTag = genaratorShortVideoDetailTag(widget.videoId.toString());

    controller = Get.find<ShortVideoDetailController>(tag: controllerTag);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => widget.child(
          controller.videoCollects.value,
          controller.updateCollects,
        ));
  }
}
