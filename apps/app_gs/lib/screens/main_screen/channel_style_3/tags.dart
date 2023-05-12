import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/channel_shared_data_controller.dart';

import 'tag.dart';

class ChannelTags extends StatelessWidget {
  final int channelId;
  const ChannelTags({Key? key, required this.channelId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final channelSharedDataController = Get.find<ChannelSharedDataController>(
      tag: '$channelId',
    );

    if (channelSharedDataController.channelSharedData.value == null) {
      return const SliverToBoxAdapter(child: SizedBox());
    }
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          var tags = channelSharedDataController.channelSharedData.value!.tags!;
          var rowIndex = index * 4;
          return Padding(
            padding:
                EdgeInsets.only(bottom: (tags.length - rowIndex) > 4 ? 10 : 0),
            child: Row(
              children: [
                for (int i = 0; i < 4; i++) ...[
                  if (tags.length > rowIndex + i)
                    Expanded(
                      flex: 1,
                      child: TagWidget(
                          id: tags[rowIndex + i].id,
                          name: tags[rowIndex + i].name),
                    ),
                ],
              ],
            ),
          );
        },
        childCount:
            (channelSharedDataController.channelSharedData.value!.tags!.length /
                    4)
                .ceil(),
      ),
    );
  }
}
