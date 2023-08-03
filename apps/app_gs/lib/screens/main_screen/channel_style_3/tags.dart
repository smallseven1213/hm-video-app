import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/channel_shared_data_controller.dart';

import '../../../widgets/header.dart';
import 'tag.dart';

class ChannelTags extends StatelessWidget {
  final int channelId;
  const ChannelTags({Key? key, required this.channelId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final channelSharedDataController = Get.find<ChannelSharedDataController>(
      tag: '$channelId',
    );

    if (channelSharedDataController.channelSharedData.value == null ||
        channelSharedDataController.channelSharedData.value!.tags == null ||
        channelSharedDataController
            .channelSharedData.value!.tags!.details!.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox());
    }

    bool hasTitle = channelSharedDataController
                .channelSharedData.value?.tags?.title !=
            null &&
        channelSharedDataController.channelSharedData.value?.tags?.title != '';
    return SliverToBoxAdapter(
      child: Column(
        children: [
          hasTitle
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Header(
                      text: channelSharedDataController
                              .channelSharedData.value?.tags?.title ??
                          ''),
                )
              : const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: (channelSharedDataController
                            .channelSharedData.value!.tags!.details!.length /
                        4)
                    .ceil(),
                itemBuilder: (BuildContext context, int index) {
                  var tags = channelSharedDataController
                      .channelSharedData.value!.tags!;
                  var rowIndex = index * 4;
                  return Padding(
                    padding: EdgeInsets.only(
                        bottom: (tags.details!.length - rowIndex) > 4 ? 10 : 0),
                    child: Row(
                      children: [
                        for (int i = 0; i < 4; i++)
                          Expanded(
                            flex: 1,
                            child: tags.details!.length > rowIndex + i
                                ? TagWidget(
                                    id: tags.details![rowIndex + i].id,
                                    name: tags.details![rowIndex + i].name,
                                    photoSid:
                                        tags.details![rowIndex + i].photoSid,
                                    outerFrame: channelSharedDataController
                                            .channelSharedData
                                            .value!
                                            .tags!
                                            .outerFrame ??
                                        false,
                                    film: tags.details![rowIndex + i].film ?? 1,
                                    channelId: channelId,
                                  )
                                : Container(), // Empty container for no data
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
