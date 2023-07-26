import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/block_controller.dart';
import '../models/channel_info.dart';

abstract class BaseVideoBlock extends StatefulWidget {
  final Blocks block;
  final int channelId;

  BaseVideoBlock({Key? key, required this.block, required this.channelId})
      : super(key: key);
}

abstract class BaseVideoBlockState<T extends BaseVideoBlock> extends State<T> {
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

  Widget buildBlockWidget(
      Blocks block, Function updateBlock, int channelId, int film);

  @override
  Widget build(BuildContext context) {
    return buildBlockWidget(
        block, updateBlock, widget.channelId, widget.block.film ?? 1);
  }
}
