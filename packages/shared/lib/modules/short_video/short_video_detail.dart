import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../controllers/short_video_detail_controller.dart';
import '../../models/short_video_detail.dart';
import '../../utils/controller_tag_genarator.dart';

final logger = Logger();

class ShortVideoDetailConsumer extends StatefulWidget {
  final int videoId;
  final String tag;
  final Widget Function(
    ShortVideoDetail? videoDetail,
  ) child;
  final Widget? loading;

  const ShortVideoDetailConsumer({
    Key? key,
    required this.child,
    required this.videoId,
    required this.tag,
    this.loading,
  }) : super(key: key);

  @override
  ShortVideoDetailConsumerState createState() =>
      ShortVideoDetailConsumerState();
}

class ShortVideoDetailConsumerState extends State<ShortVideoDetailConsumer> {
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
          controller.videoDetail.value,
        ));
  }
}
