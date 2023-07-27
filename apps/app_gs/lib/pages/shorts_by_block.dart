import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/video_short_popular_controller.dart';
import '../widgets/base_short_page.dart';

final logger = Logger();

class ShortsByBlockPage extends BaseShortPage {
  ShortsByBlockPage(
      {super.key,
      required String uuid,
      required int videoId,
      required int areaId})
      : super(
          videoId: videoId,
          itemId: areaId,
          createController: () => Get.put(
              VideoShortPopularController(areaId, videoId),
              tag: videoId.toString() + areaId.toString()),
        );
}
