import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/channel_shared_data_controller.dart';
import 'package:shared/models/channel_shared_data.dart';

import '../../models/banner_photo.dart';

class ChannelBannersConsumer extends StatelessWidget {
  final int channelId;
  final Widget Function(List<BannerPhoto> banners) child;
  const ChannelBannersConsumer(
      {Key? key, required this.channelId, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final channelSharedDataController = Get.find<ChannelSharedDataController>(
      tag: '$channelId',
    );
    return Obx(() {
      ChannelSharedData? channelSharedData =
          channelSharedDataController.channelSharedData.value;
      var banners = channelSharedData?.banner ?? [];

      return child(banners);
    });
  }
}
