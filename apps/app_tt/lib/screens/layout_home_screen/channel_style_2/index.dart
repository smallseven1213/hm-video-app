import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/video_short_by_channel_style2.dart';
import '../../../widgets/base_short_page.dart';

class ChannelStyle2 extends StatefulWidget {
  const ChannelStyle2({Key? key}) : super(key: key);

  @override
  ChannelStyle2State createState() => ChannelStyle2State();
}

class ChannelStyle2State extends State<ChannelStyle2> {
  late final VideoShortByChannelStyle2Controller _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(VideoShortByChannelStyle2Controller());
  }

  @override
  void dispose() {
    Get.delete<VideoShortByChannelStyle2Controller>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseShortPage(
      style: 2,
      createController: () => _controller,
      onScrollBeyondFirst: () {
        final controller = Get.find<VideoShortByChannelStyle2Controller>();
        controller.fetchData();
      },
    );
  }
}
