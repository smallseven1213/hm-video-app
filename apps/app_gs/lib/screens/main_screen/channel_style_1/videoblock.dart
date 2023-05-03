import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/models/channel_info.dart';
import 'package:shared/controllers/block_controller.dart';

import 'video_block_template/block_1.dart';
import 'video_block_template/block_2.dart';
import 'video_block_template/block_3.dart';
import 'video_block_template/block_4.dart';
import 'video_block_template/block_5.dart';
import 'video_block_template/block_6.dart';
import 'video_block_template/block_10.dart';
import 'video_block_template/block_7.dart';

final Map<int,
        Widget Function(Blocks block, Function updateBlock, int channelId)>
    blockMap = {
  0: (Blocks block, updateBlock, channelId) =>
      const SliverToBoxAdapter(child: SizedBox()),
  1: (Blocks block, updateBlock, channelId) => Block1Widget(
      block: block, updateBlock: updateBlock, channelId: channelId),
  2: (Blocks block, updateBlock, channelId) => Block2Widget(
      block: block, updateBlock: updateBlock, channelId: channelId),
  3: (Blocks block, updateBlock, channelId) => Block3Widget(
      block: block, updateBlock: updateBlock, channelId: channelId),
  4: (Blocks block, updateBlock, channelId) => Block4Widget(
      block: block, updateBlock: updateBlock, channelId: channelId),
  5: (Blocks block, updateBlock, channelId) => Block5Widget(
      block: block, updateBlock: updateBlock, channelId: channelId),
  6: (Blocks block, updateBlock, channelId) => Block6Widget(
      block: block, updateBlock: updateBlock, channelId: channelId),
  7: (Blocks block, updateBlock, channelId) => Block7Widget(
      block: block, updateBlock: updateBlock, channelId: channelId),
  10: (Blocks block, updateBlock, channelId) => Block10Widget(
      block: block, updateBlock: updateBlock, channelId: channelId),
};

// wrap VideoBlock with stateful widget

class VideoBlock extends StatefulWidget {
  final Blocks block;
  final int channelId;
  const VideoBlock({Key? key, required this.block, required this.channelId})
      : super(key: key);

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
    pageSize = (block.videos!.total! / block.videos!.limit!).ceil();
  }

  updateBlock() async {
    int currentPage = pageIndex >= pageSize ? 1 : pageIndex + 1;
    Blocks res =
        await blockController.mutateBybBlockId(block.id ?? 0, currentPage);

    setState(() {
      block = res;
      pageIndex = currentPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return blockMap[block.template ?? 0] == null
        ? const SliverToBoxAdapter(child: SizedBox())
        : blockMap[block.template ?? 0]!(block, updateBlock, widget.channelId);
  }
}
