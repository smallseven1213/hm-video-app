// ChannelStyle2 is a stateless widget, return Text 'STYLE 2
import 'package:flutter/material.dart';

class ChannelStyle3 extends StatelessWidget {
  final int channelId;
  const ChannelStyle3({Key? key, required this.channelId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('STYLE 3'),
    );
  }
}
