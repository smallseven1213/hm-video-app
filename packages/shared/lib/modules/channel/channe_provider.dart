import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/channel_shared_data_controller.dart';

class ChannelProvider extends StatelessWidget {
  final Widget widget;
  final int channelId;
  const ChannelProvider(
      {Key? key, required this.widget, required this.channelId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 檢查是否已存在具有特定標籤的控制器
    if (!Get.isRegistered<ChannelSharedDataController>(tag: '$channelId')) {
      // 如果不存在，則放置控制器
      Get.put(ChannelSharedDataController(channelId: channelId),
          tag: '$channelId');
    }

    return widget;
  }
}
