import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/video_short_by_tag_controller.dart';
import '../widgets/base_short_page.dart';

final logger = Logger();

class ShortsByTagPage extends BaseShortPage {
  ShortsByTagPage(
      {super.key,
      required String uuid,
      required int videoId,
      required int tagId})
      : super(
          uuid: uuid,
          videoId: videoId,
          itemId: tagId,
          createController: () => Get.put(
              VideoShortByTagController(tagId, videoId),
              tag: videoId.toString() + tagId.toString()),
        );
}
