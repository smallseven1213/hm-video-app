import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/channel_shared_data_controller.dart';
import 'package:shared/models/jingang.dart';

class ChannelJingangAreaConsumer extends StatelessWidget {
  final int channelId;
  final Widget Function(Jingang? jingang) child;
  const ChannelJingangAreaConsumer(
      {Key? key, required this.child, required this.channelId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final channelSharedDataController = Get.find<ChannelSharedDataController>(
      tag: '$channelId',
    );

    return Obx(
      () {
        Jingang? jingang =
            channelSharedDataController.channelSharedData.value?.jingang;
        return child(jingang ?? null);
      },
    );
  }
}
