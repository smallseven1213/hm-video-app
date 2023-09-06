import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/video_by_internal_tag_controller.dart';

import '../../models/vod.dart';

// 同類型
class VideoByInternalTagConsumer extends StatefulWidget {
  final String excludeId;
  final List internalTagIds;

  final Widget Function(List<Vod> videos) child;

  const VideoByInternalTagConsumer({
    Key? key,
    required this.excludeId,
    required this.internalTagIds,
    required this.child,
  }) : super(key: key);

  @override
  _VideoByInternalTagConsumerState createState() =>
      _VideoByInternalTagConsumerState();
}

class _VideoByInternalTagConsumerState
    extends State<VideoByInternalTagConsumer> {
  late VideoByInternalTagController videoByInternalTagController;

  @override
  void initState() {
    super.initState();
    String ids = widget.internalTagIds.join(',').toString();
    videoByInternalTagController = Get.put(
      VideoByInternalTagController(
        excludeId: widget.excludeId,
        internalTagId: ids,
      ),
      tag: ids,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return widget.child(videoByInternalTagController.data);
    });
  }
}
