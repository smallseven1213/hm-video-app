import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/channel_shared_data_controller.dart';

final logger = Logger();

class ChannelJingangAreaTitleConsumer extends StatelessWidget {
  final int channelId;
  final Widget Function(String? title) child;
  const ChannelJingangAreaTitleConsumer(
      {Key? key, required this.child, required this.channelId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final channelSharedDataController = Get.find<ChannelSharedDataController>(
      tag: '$channelId',
    );

    return Obx(
      () {
        return child(channelSharedDataController
            .channelSharedData.value?.jingang?.title);
      },
    );
  }
}
