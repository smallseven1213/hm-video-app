// ChannelStyle2 is a stateless widget, return Text 'STYLE 2
import 'package:flutter/material.dart';

class ChannelStyle2 extends StatelessWidget {
  final int channelId;
  const ChannelStyle2({Key? key, required this.channelId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('STYLE 2'),
    );
  }
}
