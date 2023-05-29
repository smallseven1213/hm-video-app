import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/channe_block_vod_controller.dart';

import '../../../widgets/base_video_block_template.dart';

final logger = Logger();

class Vods extends StatefulWidget {
  final ScrollController scrollController;
  final int areaId;
  final int? templateId;

  const Vods({
    Key? key,
    required this.scrollController,
    required this.areaId,
    this.templateId = 3,
  }) : super(key: key);

  @override
  VodsState createState() => VodsState();
}

class VodsState extends State<Vods> {
  ChannelBlockVodController? vodController;

  @override
  void initState() {
    super.initState();
    vodController = Get.put(
        ChannelBlockVodController(
          areaId: widget.areaId,
          scrollController: widget.scrollController,
        ),
        tag: '${widget.areaId}');

    widget.scrollController.addListener(() {
      if (widget.scrollController.offset !=
          vodController!.scrollController.offset) {
        vodController!.scrollController.jumpTo(widget.scrollController.offset);
      }
    });
    vodController!.scrollController.addListener(() {
      if (widget.scrollController.offset !=
          vodController!.scrollController.offset) {
        widget.scrollController.jumpTo(vodController!.scrollController.offset);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        // check vodController is registry and return result
        if (vodController != null) {
          return CustomScrollView(
            controller: vodController!.scrollController,
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(8.0),
                sliver: BaseVideoBlockTemplate(
                  templateId: widget.templateId ?? 3,
                  vods: vodController!.vodList.value,
                ),
              ),
            ],
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
