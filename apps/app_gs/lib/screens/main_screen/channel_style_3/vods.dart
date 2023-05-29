import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/channe_block_vod_controller.dart';

import '../../../widgets/base_video_block_template.dart';

final logger = Logger();

class Vods extends StatefulWidget {
  final int areaId;
  final int? templateId;

  const Vods({
    Key? key,
    required this.areaId,
    this.templateId = 3,
  }) : super(key: key);

  @override
  VodsState createState() => VodsState();
}

class VodsState extends State<Vods> {
  ChannelBlockVodController? vodController;
  final ScrollController _parentScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    vodController = Get.put(
        ChannelBlockVodController(
          areaId: widget.areaId,
          scrollController: _parentScrollController,
        ),
        tag: '${widget.areaId}');
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        // check vodController is registry and return result
        if (vodController != null) {
          return CustomScrollView(
            controller: PrimaryScrollController.of(context),
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
