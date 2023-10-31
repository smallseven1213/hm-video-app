import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/video_short_by_channel_style6.dart';

import '../../../controllers/tt_ui_controller.dart';
import '../../../widgets/base_short_page.dart';
import '../../../widgets/wave_loading.dart';
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
  _ChannelStyle6State createState() => _ChannelStyle6State();
}

class _ChannelStyle6State extends State<ChannelStyle6> {
  late final VideoShortByChannelStyle6Controller controller;
  final TTUIController ttUiController = Get.find<TTUIController>();

  @override
  void initState() {
    super.initState();
    controller = Get.put(VideoShortByChannelStyle6Controller());
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   ttUiController.setDarkMode(true);
    // });
    // print("@@@ ChannelStyle6 關注 initState");
  }

  @override
  void dispose() {
    // controller.dispose();'
    // print("@@@ ChannelStyle6 關注 dispose");
    Get.delete<VideoShortByChannelStyle6Controller>();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   ttUiController.setDarkMode(false);
    // });

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isInit.value == false) {
        return const Center(child: WaveLoading());
      } else {
        if (controller.data.isEmpty) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black,
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
