import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/video_short_by_channel_controller.dart';
import '../widgets/base_short_page.dart';

final logger = Logger();

class ShortsByChannelPage extends BaseShortPage {
  ShortsByChannelPage(
      {super.key,
      required String uuid,
      required int videoId,
      required int supplierId})
      : super(
          videoId: videoId,
          itemId: videoId,
          createController: () => Get.put(
              VideoShortByChannelController(supplierId, videoId),
              tag: videoId.toString() + supplierId.toString()),
        );
}
