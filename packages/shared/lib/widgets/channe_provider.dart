// ChannelProvider給ChannelPage使用, ChannelWidget會用到ChannelProvider的資料
// 所以ChannelWidget會做為一個props傳進來, 這裡會做Channel一些初始化的動作
// 也是Statefull widget, 也只有一個props: widget

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
    Get.put(ChannelSharedDataController(channelId: channelId),
        tag: '$channelId');
    return widget;
  }
}
