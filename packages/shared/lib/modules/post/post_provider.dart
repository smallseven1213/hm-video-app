import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/channel_shared_data_controller.dart';

class PostProvider extends StatelessWidget {
  final Widget widget;
  final int postId;
  const PostProvider({
    Key? key,
    required this.widget,
    required this.postId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 檢查是否已存在具有特定標籤的控制器
    if (!Get.isRegistered<ChannelSharedDataController>(tag: '$postId')) {
      // 如果不存在，則放置控制器
      Get.put(ChannelSharedDataController(channelId: postId), tag: '$postId');
    }

    return widget;
  }
}
