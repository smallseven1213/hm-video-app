// 給各Channel共用的ChannelBanners(最上方輪播)
// is a stateless widget, has props: channelId
// getx find channelSharedDataController, args is channelId: channelId

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/channel_shared_data_controller.dart';
import 'package:shared/models/channel_shared_data.dart';
import 'package:app_gs/widgets/carousel.dart';

class ChannelBanners extends StatelessWidget {
  final int channelId;
  const ChannelBanners({Key? key, required this.channelId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final channelSharedDataController = Get.find<ChannelSharedDataController>(
      tag: '$channelId',
    );
    return Obx(() {
      ChannelSharedData? channelSharedData =
          channelSharedDataController.channelSharedData.value;
      bool bannerIsEmpty = channelSharedData?.banner == null ||
          channelSharedData!.banner!.isEmpty;

      if (channelSharedData == null || bannerIsEmpty) {
        return const SliverToBoxAdapter(child: SizedBox.shrink());
      } else {
        return SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Carousel(
              images: channelSharedData.banner,
              ratio: 359 / 170,
            ),
          ),
        );
      }
    });
  }
}
