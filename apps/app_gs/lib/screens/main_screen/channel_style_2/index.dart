import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/video_short_by_channel_style2.dart';

import '../../../widgets/base_short_page.dart';
import 'suppliers.dart';

class ChannelStyle2ShortsPart extends BaseShortPage {
  ChannelStyle2ShortsPart({
    super.key,
    required VideoShortByChannelStyle2Controller controller,
  }) : super(
          style: 2,
          createController: () =>
              Get.find<VideoShortByChannelStyle2Controller>(),
          onScrollBeyondFirst: () {
            final controller = Get.find<VideoShortByChannelStyle2Controller>();
            controller.fetchData();
          },
        );
}

class ChannelStyle2 extends StatelessWidget {
  ChannelStyle2({Key? key}) : super(key: key);

  final VideoShortByChannelStyle2Controller controller =
      Get.put(VideoShortByChannelStyle2Controller());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.data.isEmpty) {
        return Center(
          child: ChannelStyle2Suppliers(),
        );
      }

      return ChannelStyle2ShortsPart(controller: controller);
    });
  }
}
