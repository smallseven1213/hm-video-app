import 'package:flutter/material.dart';
import 'package:shared/models/slim_channel.dart';
import 'package:shared/modules/main_layout/channels_scaffold.dart';

import 'channel_style_1/index.dart';
import 'channel_style_2/index.dart';
import 'channel_style_3/index.dart';
// import 'channel_style_4/index.dart';
// import 'channel_style_5/index.dart';
import 'channel_style_not_found/index.dart';

Map<int, Function(SlimChannel channelData, int layoutId)> styleWidgetMap = {
  1: (channelData, layoutId) => ChannelStyle1(
        key: ValueKey(channelData.id),
        channelId: channelData.id,
        layoutId: layoutId,
      ),
  2: (channelData, layoutId) => ChannelStyle2(
        key: ValueKey(channelData.id),
      ),
  3: (channelData, layoutId) => ChannelStyle3(
        key: ValueKey(channelData.id),
        channelId: channelData.id,
        layoutId: layoutId,
      ),
  // 4: (channelData, layoutId) => ChannelStyle4(
  //       key: ValueKey(channelData.id),
  //       channelId: channelData.id,
  //       layoutId: layoutId,
  //     ),
  // 5: (channelData, layoutId) => ChannelStyle5(
  //       key: ValueKey(channelData.id),
  //       channelId: channelData.id,
  //       layoutId: layoutId,
  //     ),
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
