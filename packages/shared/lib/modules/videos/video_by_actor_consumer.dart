import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/video_by_actor_controller.dart';
import '../../models/vod.dart';

class VideoByActorConsumer extends StatefulWidget {
  final String excludeId;
  final List actorId;
  final Widget Function(List<Vod> videos) child;

  const VideoByActorConsumer({
    Key? key,
    required this.excludeId,
    required this.actorId,
    required this.child,
  }) : super(key: key);

  @override
  _VideoByActorConsumerState createState() => _VideoByActorConsumerState();
}

class _VideoByActorConsumerState extends State<VideoByActorConsumer> {
  late VideoByActorController videoByActorController;

  @override
  void initState() {
    super.initState();
    String ids = widget.actorId.map((e) => e.id.toString()).join(',');
    videoByActorController = Get.put(
      VideoByActorController(
        excludeId: widget.excludeId,
        actorId: ids,
      ),
      tag: '${ids}_${widget.excludeId}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return widget.child(videoByActorController.data);
    });
  }
}
