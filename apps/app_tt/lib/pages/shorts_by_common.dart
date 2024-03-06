import 'package:get/get.dart';
import 'package:shared/controllers/video_shorts_controller.dart';
import 'package:shared/enums/shorts_type.dart';
import '../widgets/base_short_page.dart';

class ShortsByCommonPage extends BaseShortPage {
  ShortsByCommonPage(
      {super.key,
      required String uuid,
      required int videoId,
      required int id, // type=1 id表示supplierId, type=2. id表示tagId
      required ShortsType type})
      : super(
          uuid: uuid,
          videoId: videoId,
          itemId: id,
          createController: () => Get.put(
              VideoShortsController(type, id, videoId),
              tag: type.toString() + videoId.toString() + id.toString()),
          controllerTag: type.toString() + videoId.toString() + id.toString(),
        );
}
