import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart' as rx;
import 'package:shared/models/index.dart';
import '../../controllers/play_record_controller.dart';
import '../../controllers/short_video_detail_controller.dart';
import '../../utils/controller_tag_genarator.dart';

final logger = Logger();

class ShortVideoProvider extends StatefulWidget {
  final int vodId;
  final Widget child;
  final Widget? loading;

  const ShortVideoProvider({
    Key? key,
    required this.child,
    required this.vodId,
    this.loading,
  }) : super(key: key);

  @override
  ShortVideoProviderState createState() => ShortVideoProviderState();
}

class ShortVideoProviderState extends State<ShortVideoProvider> {
  late final String controllerTag;
  late final ShortVideoDetailController controller;

  @override
  void initState() {
    super.initState();

    controllerTag = genaratorShortVideoDetailTag(widget.vodId.toString());

    controller =
        Get.put(ShortVideoDetailController(widget.vodId), tag: controllerTag);

    controller.video.stream.listen((value) {
      if (value != null) {
        var playRecord = Vod(
          value.id,
          value.title,
          coverHorizontal: value.coverHorizontal!,
          coverVertical: value.coverVertical!,
          timeLength: value.timeLength!,
          tags: value.tags!,
          videoViewTimes: value.videoViewTimes!,
        );
        Get.find<PlayRecordController>(tag: 'short').addPlayRecord(playRecord);
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    Get.delete(tag: controllerTag);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
