import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../controllers/short_video_detail_controller.dart';
import '../../models/short_video_detail.dart';
import '../../models/vod.dart';

final logger = Logger();

class ShortVideoConsumer extends StatefulWidget {
  final int vodId;
  final String tag;
  final Widget Function({
    required bool isLoading,
    required String? videoUrl,
    required Vod? video,
    required Vod? videoDetail,
  }) child;
  final Widget? loading;

  const ShortVideoConsumer({
    Key? key,
    required this.child,
    required this.vodId,
    required this.tag,
    this.loading,
  }) : super(key: key);

  @override
  ShortVideoConsumerState createState() => ShortVideoConsumerState();
}

class ShortVideoConsumerState extends State<ShortVideoConsumer> {
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
          isLoading: controller.isLoading.value,
          videoUrl: controller.videoUrl.value,
          video: controller.video.value,
          videoDetail: controller.videoDetail.value,
        ));
  }
}
