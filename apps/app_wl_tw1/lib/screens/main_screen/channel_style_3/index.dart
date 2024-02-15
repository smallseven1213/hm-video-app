import 'package:flutter/material.dart';
import 'package:shared/modules/channel/channe_provider.dart';
import 'package:shared/modules/main_layout/display_layout_tab_search_consumer.dart';

import 'main.dart';

class ChannelStyle3 extends StatelessWidget {
  final int channelId;
  final int layoutId;
  const ChannelStyle3(
      {Key? key, required this.channelId, required this.layoutId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DisplayLayoutTabSearchConsumer(
      layoutId: layoutId,
      child: ({required bool displaySearchBar}) => Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.paddingOf(context).top +
                (displaySearchBar ? 90 : 50)),
        child: ChannelProvider(
            channelId: channelId,
            widget: ChannelStyle3Main(
              key: Key('$channelId'),
              channelId: channelId,
            )),
      ),
    );
  }
}
