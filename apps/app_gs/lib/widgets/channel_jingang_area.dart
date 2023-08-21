import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:logger/logger.dart';
import 'package:shared/enums/jingang.dart';
import 'package:shared/modules/channel/channel_jingang_area_consumer.dart';

import 'jingang_button.dart';

final logger = Logger();

class ChannelJingangArea extends StatelessWidget {
  final int channelId;
  const ChannelJingangArea({Key? key, required this.channelId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChannelJingangAreaConsumer(
      channelId: channelId,
      child: (jingang) {
        if (jingang == null ||
            jingang.jingangDetail == null ||
            jingang.jingangDetail!.isEmpty) {
          return const SliverToBoxAdapter(child: SizedBox());
        }

        if (jingang.jingangStyle == JingangStyle.single.index) {
          return SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.of(context).size.width * 0.26,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: jingang.jingangDetail?.length ?? 0,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 8.0),
                    child: JingangButton(
                      item: jingang.jingangDetail![index],
                      outerFrame: OuterFrame.border.value,
                      outerFrameStyle: jingang.outerFrameStyle ??
                          OuterFrameStyle.circle.index,
                    ),
                  );
                },
              ),
            ),
          );
        }
        return SliverPadding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          sliver: SliverAlignedGrid.count(
            crossAxisCount: jingang.quantity ?? 4,
            itemCount: jingang.jingangDetail?.length ?? 0,
            itemBuilder: (BuildContext context, int index) => Container(
              child: JingangButton(
                item: jingang.jingangDetail![index],
                outerFrame: jingang.outerFrame ?? OuterFrame.border.value,
                outerFrameStyle:
                    jingang.outerFrameStyle ?? OuterFrameStyle.circle.index,
              ),
            ),
            mainAxisSpacing: 12.0,
            crossAxisSpacing: 8.0,
          ),
        );
      },
    );
  }
}
