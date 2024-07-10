import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/video_short_by_channel_style6.dart';

import '../../../widgets/base_short_page.dart';

class ChannelStyle7ShortsPart extends BaseShortPage {
  ChannelStyle7ShortsPart({
    super.key,
    required VideoShortByChannelStyle6Controller controller,
  }) : super(
          style: 2,
          createController: () =>
              Get.find<VideoShortByChannelStyle6Controller>(),
          onScrollBeyondFirst: () {
            final controller = Get.find<VideoShortByChannelStyle6Controller>();
            controller.fetchData();
          },
        );
}

class ChannelStyle7 extends StatefulWidget {
  const ChannelStyle7({Key? key}) : super(key: key);

  @override
  ChannelStyle7State createState() => ChannelStyle7State();
}

class ChannelStyle7State extends State<ChannelStyle7> {
  // late final VideoShortByChannelStyle7Controller controller;

  @override
  void initState() {
    super.initState();
    // controller = Get.put(VideoShortByChannelStyle7Controller());
  }

  @override
  void dispose() {
    // controller.dispose();
    // Get.delete<VideoShortByChannelStyle7Controller>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
    // return Obx(() {
    //   if (controller.isInit.value == false) {
    //     return const Center(
    //       child: FlashLoading(),
    //     );
    //   } else {
    //     if (controller.data.isEmpty) {
    //       return Container(
    //         width: double.infinity,
    //         height: double.infinity,
    //         color: AppColors.colors[ColorKeys.primary],
    //         child: const Center(),
    //       );
    //     }

    //     return ChannelStyle7ShortsPart(controller: controller);
    //   }
    // });
  }
}
