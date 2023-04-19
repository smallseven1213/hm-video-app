import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/channel_data_controller.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/models/channel_info.dart';
import 'package:shared/navigator/delegate.dart';

import '../../../widgets/channel_skelton.dart';
import '../../../widgets/header.dart';
import 'banners.dart';
import 'jingang.dart';
import 'videoblock.dart';

final logger = Logger();

class Channel extends StatelessWidget {
  final int channelId;

  const Channel({Key? key, required this.channelId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final channelDataController = Get.find<ChannelDataController>(
      tag: 'channelId-$channelId',
    );

    return Obx(() {
      ChannelInfo? channelData = channelDataController.channelData.value;

      if (channelData == null) {
        return const ChannelSkeleton();
      } else {
        List<Widget> sliverBlocks = [];
        for (var block in channelData.blocks!) {
          sliverBlocks.add(SliverToBoxAdapter(
            child: Header(
              text: '${block.name} [${block.template}]',
              moreButton: block.isMore!
                  ? InkWell(
                      onTap: () => {
                            MyRouteDelegate.of(context).push(
                              AppRoutes.videoByBlock.value,
                              args: {
                                'id': block.id,
                                'title': block.name,
                                'channelId': channelId,
                              },
                            )
                          },
                      child: const Text(
                        '更多 >',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ))
                  : null,
            ),
          ));
          sliverBlocks.add(const SliverToBoxAdapter(
            child: SizedBox(height: 5),
          ));
          sliverBlocks.add(VideoBlock(block: block, channelId: channelId));
          sliverBlocks.add(const SliverToBoxAdapter(
            child: SizedBox(height: 10),
          ));
        }

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: Banners(channelId: channelId)),
            JingangList(channelId: channelId),
            ...sliverBlocks,
            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            )
          ],
        );
      }
    });
  }
}
