import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/video_by_tag_controller.dart';
import '../../models/vod.dart';

// 同標籤
class VideoByTagConsumer extends StatefulWidget {
  final String excludeId;
  final List tags;
  final Widget Function(List<Vod> videos) child;

  const VideoByTagConsumer({
    Key? key,
    required this.excludeId,
    required this.tags,
    required this.child,
  }) : super(key: key);

  @override
  VideoByTagConsumerState createState() => VideoByTagConsumerState();
}

class VideoByTagConsumerState extends State<VideoByTagConsumer> {
  late VideoByTagController videoByTagController;

  @override
  void initState() {
    super.initState();
    String ids = widget.tags.take(3).map((e) => e.id.toString()).join(',');
    videoByTagController = Get.put(
      VideoByTagController(
        excludeId: widget.excludeId,
        tagId: ids,
      ),
      tag: '${ids}_${widget.excludeId}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return widget.child(videoByTagController.data);
    });
  }
}
