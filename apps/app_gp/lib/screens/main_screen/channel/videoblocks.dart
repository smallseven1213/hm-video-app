import 'package:app_gp/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/channel_data_controller.dart';
import 'package:shared/models/channel_info.dart';
import 'package:shared/models/color_keys.dart';

import 'video_block_template/block_1.dart';
import 'video_block_template/block_2.dart';
import 'videoblock.dart';

final logger = Logger();

class VideoBlocks extends StatelessWidget {
  final int channelId;

  VideoBlocks({Key? key, required this.channelId}) : super(key: key);

  final ChannelDataController channelDataController =
      Get.find<ChannelDataController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.colors[ColorKeys.background],
      child: Obx(() {
        ChannelInfo? channelData = channelDataController.channelData[channelId];
        if (channelData == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: channelData.blocks?.length ?? 0,
          itemBuilder: (context, index) {
            return VideoBlock(block: channelData.blocks![index]);
          },
        );
      }),
    );
  }
}
