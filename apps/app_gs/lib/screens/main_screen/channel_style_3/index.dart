import 'package:flutter/material.dart';
import 'package:shared/widgets/channe_provider.dart';
import 'package:shared/widgets/display_layout_tab_search.dart';
import 'main.dart';

class ChannelStyle3 extends StatelessWidget {
  final int channelId;
  final int layoutId;
  const ChannelStyle3(
      {Key? key, required this.channelId, required this.layoutId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DisplayLayoutTabSearch(
      layoutId: layoutId,
      child: ({required bool displaySearchBar}) => Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top +
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
