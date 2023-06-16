import 'package:flutter/material.dart';
import 'package:shared/widgets/channe_provider.dart';
import 'main.dart';

class ChannelStyle3 extends StatelessWidget {
  final int channelId;
  const ChannelStyle3({Key? key, required this.channelId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChannelProvider(
        channelId: channelId,
        widget: ChannelStyle3Main(
          channelId: channelId,
        ));
  }
}
