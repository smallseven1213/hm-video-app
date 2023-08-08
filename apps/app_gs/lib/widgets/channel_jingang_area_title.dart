import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared/modules/channel/channel_jingang_area_title_consumer.dart';

import 'header.dart';

final logger = Logger();

class ChannelJingangAreaTitle extends StatelessWidget {
  final int channelId;
  const ChannelJingangAreaTitle({Key? key, required this.channelId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChannelJingangAreaTitleConsumer(
      channelId: channelId,
      child: (title) => title == null
          ? const SliverToBoxAdapter(child: SizedBox.shrink())
          : SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Header(text: title),
              ),
            ),
    );
  }
}
