import 'package:app_gp/config/colors.dart';
import 'package:app_gp/screens/main_screen/channel/videoblocks.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/channel_data_controller.dart';
import 'package:shared/models/block.dart';
import 'package:shared/models/color_keys.dart';

import 'banners.dart';
import 'jingang.dart';

final logger = Logger();

// ChannelWidget, 由上到下是 BannerWidget, JingangWidget, then ChannelWidget

class Channel extends StatelessWidget {
  final int channelId;

  Channel({Key? key, required this.channelId}) : super(key: key);

  final ChannelDataController channelDataController =
      Get.find<ChannelDataController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colors[ColorKeys.background],
      body: Row(
        children: [
          Banners(channelId: channelId),
          // Jingang(channelId: channelId),
          VideoBlocks(channelId: channelId)
        ],
      ),
    );
  }
}
