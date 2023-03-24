import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/models/channel_info.dart';
import 'package:shared/controllers/block_controller.dart';

import '../../../widgets/header.dart';
import 'video_block_template/block_1.dart';
import 'video_block_template/block_2.dart';
import 'video_block_template/block_3.dart';
import 'video_block_template/block_4.dart';
import 'video_block_template/block_5.dart';
import 'video_block_template/block_6.dart';
import 'video_block_template/block_10.dart';

final Map<int, Widget Function(Blocks block, Function updateBlock)> blockMap = {
  0: (Blocks block, updateBlock) => const SizedBox(),
  1: (Blocks block, updateBlock) =>
      Block1Widget(block: block, updateBlock: updateBlock),
  2: (Blocks block, updateBlock) =>
      Block2Widget(block: block, updateBlock: updateBlock),
  3: (Blocks block, updateBlock) =>
      Block3Widget(block: block, updateBlock: updateBlock),
  4: (Blocks block, updateBlock) =>
      Block4Widget(block: block, updateBlock: updateBlock),
  5: (Blocks block, updateBlock) =>
      Block5Widget(block: block, updateBlock: updateBlock),
  6: (Blocks block, updateBlock) =>
      Block6Widget(block: block, updateBlock: updateBlock),
  10: (Blocks block, updateBlock) =>
      Block10Widget(block: block, updateBlock: updateBlock),
};

// wrap VideoBlock with stateful widget

class VideoBlock extends StatefulWidget {
  final Blocks block;
  const VideoBlock({Key? key, required this.block}) : super(key: key);

  @override
  _VideoBlockStatefulState createState() => _VideoBlockStatefulState();
}

class _VideoBlockStatefulState extends State<VideoBlock> {
  // use getx put VideoBlockController here
  final BlockController blockController = Get.put(BlockController());

  Blocks block = Blocks();
  int pageIndex = 1;
  int pageSize = 10;

  @override
  void initState() {
    super.initState();
    block = widget.block;
  }

  updateBlock() async {
    int currentPage = pageIndex >= pageSize ? 1 : pageIndex + 1;
    Blocks res =
        await blockController.mutateBybBlockId(block.id ?? 0, currentPage);

    setState(() {
      block = res;
      pageIndex = currentPage;
      pageSize = (res.videos!.total! / res.videos!.limit!).ceil();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Header(
            text: '${block.name} [${block.template}]',
          ),
          const SizedBox(
            height: 5,
          ),
          blockMap[block.template ?? 0] == null
              ? const SizedBox()
              : blockMap[block.template ?? 0]!(block, updateBlock),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
