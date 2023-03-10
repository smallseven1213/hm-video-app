import 'package:app_gp/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/channel_data_controller.dart';
import 'package:shared/models/color_keys.dart';

import '../../pages/video.dart';

class MainChannelScreen extends StatelessWidget {
  final int channelId;

  MainChannelScreen({Key? key, required this.channelId}) : super(key: key);

  final ChannelDataController channelDataController =
      Get.find<ChannelDataController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colors[ColorKeys.background],
      body: Obx(
        () => ListView.builder(
          itemCount: channelDataController.channelData[channelId]?.length,
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
                  // child: Text(
                  //     channelDataController.channelData[channelId]![index].name),
                  child: Text('Video')),
            );
          },
        ),
      ),
    );
  }
}
