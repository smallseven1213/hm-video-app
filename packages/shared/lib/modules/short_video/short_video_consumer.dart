import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../controllers/short_video_detail_controller.dart';
import '../../models/short_video_detail.dart';
import '../../models/vod.dart';
import '../../utils/controller_tag_genarator.dart';

final logger = Logger();

class ShortVideoConsumer extends StatefulWidget {
  final int vodId;
  final Widget Function({
    required bool isLoading,
    required String? videoUrl,
    required Vod? video,
    required ShortVideoDetail? videoDetail,
  }) child;
  final Widget? loading;

  const ShortVideoConsumer({
    Key? key,
    required this.child,
    required this.vodId,
    this.loading,
  }) : super(key: key);

  @override
  ShortVideoConsumerState createState() => ShortVideoConsumerState();
}

class ShortVideoConsumerState extends State<ShortVideoConsumer> {
  late final String controllerTag;
  late final ShortVideoDetailController controller;

  @override
  void initState() {
    super.initState();

    controllerTag = genaratorShortVideoDetailTag(widget.vodId.toString());
    controller = Get.find<ShortVideoDetailController>(tag: controllerTag);
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
