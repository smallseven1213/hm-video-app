import 'package:flutter/material.dart';
import 'package:shared/widgets/channe_provider.dart';
import 'main.dart';

class ChannelStyle3 extends StatelessWidget {
  final int channelId;
  final int layoutId;
  const ChannelStyle3(
      {Key? key, required this.channelId, required this.layoutId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 90),
      child: ChannelProvider(
          channelId: channelId,
          widget: ChannelStyle3Main(
            key: Key('$channelId'),
            channelId: channelId,
          )),
    );
  }
}
