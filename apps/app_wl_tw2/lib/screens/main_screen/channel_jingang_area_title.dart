import 'package:app_wl_tw2/screens/main_screen/block_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/channel_shared_data_controller.dart';

class ChannelJingangAreaTitle extends StatelessWidget {
  final int channelId;
  const ChannelJingangAreaTitle({Key? key, required this.channelId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final channelSharedDataController = Get.find<ChannelSharedDataController>(
      tag: '$channelId',
    );

    return Obx(
      () {
        if (channelSharedDataController
                .channelSharedData.value?.jingang?.title !=
            null) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: BlockHeader(
                  text: channelSharedDataController
                          .channelSharedData.value?.jingang?.title ??
                      ''),
            ),
          );
        }
        return const SliverToBoxAdapter(child: SizedBox());
      },
    );
  }
}
