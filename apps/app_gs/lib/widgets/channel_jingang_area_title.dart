import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/channel_shared_data_controller.dart';

import 'header.dart';

final logger = Logger();

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
              child: Header(
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
