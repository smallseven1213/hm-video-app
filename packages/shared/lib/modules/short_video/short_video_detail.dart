import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../controllers/short_video_detail_controller.dart';
import '../../models/short_video_detail.dart';
import '../../utils/controller_tag_genarator.dart';

final logger = Logger();

class ShortVideoDetailConsumer extends StatefulWidget {
  final int videoId;
  final Widget Function(
    ShortVideoDetail? videoDetail,
  ) child;
  final Widget? loading;

  const ShortVideoDetailConsumer({
    Key? key,
    required this.child,
    required this.videoId,
    this.loading,
  }) : super(key: key);

  @override
  ShortVideoDetailConsumerState createState() =>
      ShortVideoDetailConsumerState();
}

class ShortVideoDetailConsumerState extends State<ShortVideoDetailConsumer> {
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
          controller.videoDetail.value,
        ));
  }
}
