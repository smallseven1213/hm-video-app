import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/channel_shared_data_controller.dart';
import 'package:shared/models/channel_shared_data.dart';
import 'package:app_gs/widgets/carousel.dart';
import 'package:shared/models/jingang.dart';

import 'header.dart';
import 'jingang_button.dart';

final logger = Logger();

class ChannelJingangArea extends StatelessWidget {
  final int channelId;
  const ChannelJingangArea({Key? key, required this.channelId})
      : super(key: key);

  Widget buildTitle(String title) {
    if (title == '') return const SizedBox();
    return Header(text: title);
  }

  @override
  Widget build(BuildContext context) {
    final channelSharedDataController = Get.find<ChannelSharedDataController>(
      tag: '$channelId',
    );

    if (channelSharedDataController.channelSharedData.value == null) {
      return const SliverToBoxAdapter(child: SizedBox());
    }
    return Obx(
      () {
        Jingang? jingang =
            channelSharedDataController.channelSharedData.value!.jingang;
        if (jingang == null ||
            jingang.jingangDetail == null ||
            jingang.jingangDetail!.isEmpty) {
          return const SliverToBoxAdapter(child: SizedBox());
        }

        if (jingang.jingangStyle == JingangStyle.single.index) {
          return SliverToBoxAdapter(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: jingang.jingangDetail?.length ?? 0,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16.0),
                  child: JingangButton(
                    item: jingang.jingangDetail![index],
                    outerFrame: OuterFrame.border.value,
                    outerFrameStyle:
                        jingang.outerFrameStyle ?? OuterFrameStyle.circle.index,
                  ),
                );
              },
            ),
          );
        }
        return SliverPadding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
          sliver: SliverAlignedGrid.count(
            crossAxisCount: jingang.quantity ?? 4,
            itemCount: jingang.jingangDetail?.length ?? 0,
            itemBuilder: (BuildContext context, int index) => JingangButton(
              item: jingang.jingangDetail![index],
              outerFrame: jingang.outerFrame ?? OuterFrame.border.value,
              outerFrameStyle:
                  jingang.outerFrameStyle ?? OuterFrameStyle.circle.index,
            ),
            mainAxisSpacing: 12.0,
            crossAxisSpacing: 10.0,
          ),
        );
      },
    );
  }
}
