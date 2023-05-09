// ChannelStyle2 is a stateless widget, return Text 'STYLE 2
import 'package:flutter/material.dart';

import '../../../widgets/shortcard/index.dart';

class ChannelStyle2 extends StatelessWidget {
  final int channelId;
  const ChannelStyle2({Key? key, required this.channelId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: 1000,
      itemBuilder: (BuildContext context, int index) {
        // return ShortCard(
        //   index: index, id: null,
        // );
      },
    );
  }
}
