import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../controllers/short_video_detail_controller.dart';
import '../../models/short_video_detail.dart';
import '../../models/vod.dart';
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

    Get.put(ShortVideoDetailController(widget.vodId), tag: controllerTag);

    // if (widget.supportedPlayRecord == true) {
    //   var videoVal = videoDetailController.video.value;
    //   var playRecord = Vod(
    //     videoVal!.id,
    //     videoVal.title,
    //     coverHorizontal: videoVal.coverHorizontal!,
    //     coverVertical: videoVal.coverVertical!,
    //     timeLength: videoVal.timeLength!,
    //     tags: videoVal.tags!,
    //     videoViewTimes: videoVal.videoViewTimes!,
    //   );
    //   Get.find<PlayRecordController>(tag: 'short').addPlayRecord(playRecord);
    // }
  }

  @override
  void dispose() {
    // controller.dispose();
    // Get.delete(tag: controllerTag);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
