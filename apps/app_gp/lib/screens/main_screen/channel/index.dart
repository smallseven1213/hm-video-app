import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/channel_data_controller.dart';
import 'package:shared/models/channel_info.dart';

import '../../../widgets/header.dart';
import 'banners.dart';
import 'jingang.dart';
import 'videoblock.dart';

final logger = Logger();

// ChannelWidget, 由上到下是 BannerWidget, JingangWidget, then ChannelWidget

class Channel extends StatelessWidget {
  final int channelId;

  Channel({Key? key, required this.channelId}) : super(key: key);

  final ChannelDataController channelDataController =
      Get.find<ChannelDataController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      ChannelInfo? channelData = channelDataController.channelData[channelId];

      List<Widget> sliverBlocks = [];
      if (channelData != null) {
        for (var block in channelData.blocks!) {
          sliverBlocks.add(SliverToBoxAdapter(
            child: Header(
              text: '${block.name} [${block.template}]',
            ),
          ));
          sliverBlocks.add(const SliverToBoxAdapter(
            child: SizedBox(height: 5),
          ));
          sliverBlocks.add(VideoBlock(block: block, channelId: channelId));
          sliverBlocks.add(const SliverToBoxAdapter(
            child: SizedBox(height: 10),
          ));
        }
      }

      return CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: Banners(channelId: channelId)),
          JingangList(channelId: channelId),
          ...sliverBlocks,
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          )
        ],
      );
    });
  }
}
