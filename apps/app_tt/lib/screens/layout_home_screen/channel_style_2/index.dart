import 'package:get/get.dart';
import 'package:shared/controllers/video_short_by_channel_style2.dart';

import '../../../widgets/base_short_page.dart';

class ChannelStyle2 extends BaseShortPage {
  ChannelStyle2({
    super.key,
  }) : super(
          hiddenBottomArea: true,
          createController: () =>
              Get.put(VideoShortByChannelStyle2Controller()),
        );
}
