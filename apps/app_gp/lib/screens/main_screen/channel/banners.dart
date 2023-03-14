// Banners

import 'package:app_gp/widgets/carousel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/channel_data_controller.dart';
import 'package:shared/models/channel_info.dart';

class Banners extends StatelessWidget {
  final int channelId;
  Banners({Key? key, required this.channelId}) : super(key: key);
  final ChannelDataController channelDataController =
      Get.find<ChannelDataController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      ChannelInfo? channelData = channelDataController.channelData[channelId];
      if (channelData?.banner == null) {
        return const SizedBox();
      }
      return Carousel(images: channelData?.banner);
    });
  }
}
