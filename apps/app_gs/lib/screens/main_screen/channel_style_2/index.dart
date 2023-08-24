import 'package:get/get.dart';
import 'package:shared/controllers/video_short_by_channel_style2.dart';

import '../../../widgets/base_short_page.dart';

class ChannelStyle2 extends BaseShortPage {
  ChannelStyle2({
    super.key,
  }) : super(
          style: 2,
          createController: () =>
              Get.put(VideoShortByChannelStyle2Controller()),
          onScrollBeyondFirst: () {
            print('XDDD');
            // final controller = Get.find<VideoShortByChannelStyle2Controller>();
            // controller.fetchData();
          },
        );
}
