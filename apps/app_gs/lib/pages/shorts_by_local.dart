import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/play_record_controller.dart';
import 'package:shared/controllers/user_favorites_short_controlle.dart';
import 'package:shared/controllers/user_short_collection_controller.dart';
import 'package:shared/controllers/video_short_by_tag_controller.dart';
import '../widgets/base_short_page.dart';

final logger = Logger();

/**
 * 適用於Collection, Playrecord and Favorites
 * itemId:
 * 0 - Collection
 * 1 - Playrecord
 * 2 - Favorites
 */
class ShortsByLocalPage extends BaseShortPage {
  ShortsByLocalPage(
      {super.key,
      required int videoId,
      required int itemId,
      bool? supportedPlayRecord = true})
      : super(
          supportedPlayRecord: supportedPlayRecord,
          videoId: videoId,
          itemId: itemId,
          createController: () {
            if (itemId == 0) {
              return Get.find<UserShortCollectionController>();
            } else if (itemId == 1) {
              return Get.find<PlayRecordController>(tag: 'short');
            } else if (itemId == 2) {
              return Get.find<UserFavoritesShortController>();
            } else {
              logger.e('itemId is not 0, 1 or 2');
              return Get.find<UserShortCollectionController>();
            }
          },
        );
}
