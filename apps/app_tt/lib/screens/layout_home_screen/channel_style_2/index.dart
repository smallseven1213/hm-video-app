import 'package:get/get.dart';
import 'package:shared/controllers/video_short_by_channel_style2.dart';
import 'package:uuid/uuid.dart';

class ChannelStyle2 extends BaseShortPage {
  ChannelStyle2({
    super.key,
  }) : super(
          uuid: const Uuid().v4(),
          hiddenBottomArea: true,
          createController: () =>
              Get.put(VideoShortByChannelStyle2Controller()),
        );
}
