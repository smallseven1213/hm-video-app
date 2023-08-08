import 'package:flutter/material.dart';
import 'package:shared/modules/main_layout/channels_scaffold.dart';
import 'channel_style_1/index.dart';

import 'channel_style_2/index.dart';
import 'channel_style_3/index.dart';
import 'channel_style_4/index.dart';
import 'channel_style_5/index.dart';
import 'channel_style_not_found/index.dart';

Map<int, Function> styleWidgetMap = {
  1: (item) => ChannelStyle1(
        key: ValueKey(item.id),
        channelId: item.id,
      ),
  2: (item) => ChannelStyle2(
        key: ValueKey(item.id),
      ),
  3: (item) => ChannelStyle3(
        key: ValueKey(item.id),
        channelId: item.id,
      ),
  4: (item) => ChannelStyle4(
        key: ValueKey(item.id),
        channelId: item.id,
      ),
  5: (item) => ChannelStyle5(
        key: ValueKey(item.id),
        channelId: item.id,
      ),
};

class Channels extends StatelessWidget {
  final int layoutId;
  const Channels({Key? key, required this.layoutId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChannelsScaffold(
        layoutId: layoutId,
        child: (channelData) {
          var getWidget = styleWidgetMap[channelData.style];
          if (getWidget == null) {
            return const ChannelStyleNotFound();
          }
          return getWidget(channelData, layoutId);
        });
  }
}
