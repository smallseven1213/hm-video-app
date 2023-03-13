import 'package:app_gp/config/colors.dart';
import 'package:app_gp/screens/main_screen/layout_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/channel_data_controller.dart';
import 'package:shared/models/block.dart';
import 'package:shared/models/color_keys.dart';

import '../../../pages/video.dart';

final logger = Logger();

class VideoBlocks extends StatelessWidget {
  final int channelId;

  VideoBlocks({Key? key, required this.channelId}) : super(key: key);

  final ChannelDataController channelDataController =
      Get.find<ChannelDataController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colors[ColorKeys.background],
      body: Obx(() {
        List<Block>? channelData = channelDataController.channelData[channelId];
        if (channelData == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: channelData.length,
          itemBuilder: (context, index) {
            return Container(
              height: 100,
              color: AppColors.colors[ColorKeys.background],
              child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Video()),
                    );
                  },
                  child: Text(channelData[index].name ?? 'Nothing More')),
              // child: Text('hi')),
            );
          },
        );
      }),
    );
  }
}
