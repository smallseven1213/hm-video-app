import 'package:app_sv/config/colors.dart';
import 'package:app_sv/widgets/flash_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/video_short_by_channel_style6.dart';
import 'package:shared/models/color_keys.dart';

import '../../../widgets/base_short_page.dart';
import 'suppliers.dart';

class ChannelStyle6ShortsPart extends BaseShortPage {
  ChannelStyle6ShortsPart({
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

class ChannelStyle6 extends StatefulWidget {
  const ChannelStyle6({Key? key}) : super(key: key);

  @override
  ChannelStyle6State createState() => ChannelStyle6State();
}

class ChannelStyle6State extends State<ChannelStyle6> {
  late final VideoShortByChannelStyle6Controller controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(VideoShortByChannelStyle6Controller());
  }

  @override
  void dispose() {
    // controller.dispose();
    Get.delete<VideoShortByChannelStyle6Controller>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isInit.value == false) {
        return const Center(
          child: FlashLoading(),
        );
      } else {
        if (controller.data.isEmpty) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            color: AppColors.colors[ColorKeys.primary],
            child: Center(
              child: ChannelStyle6Suppliers(),
            ),
          );
        }

        return ChannelStyle6ShortsPart(controller: controller);
      }
    });
  }
}
