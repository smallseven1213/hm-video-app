import 'package:get/get.dart';
import 'package:wgp_video_h5app/models/index.dart';
import 'package:wgp_video_h5app/providers/index.dart';

class VPublisherController extends GetxController {
  Publisher publisher = Publisher(0, '', '');
  List<BlockVod> publisherVods = [BlockVod([], 0)];
  List<Vod> vods = [];
  bool loading = false;
  int lastestOrderBy = 0;

  Future<void> getPublisher(int publisherId) async {
    publisher = await Get.find<PublisherProvider>().getOne(publisherId);
    update();
  }

  disposePublisher() {
    vods = [];
    publisher = Publisher(0, '', '');
    update();
  }

  Future<void> getPublisherVods(
    int publisherId, {
    int orderBy = 0,
    int page = 1,
    int limit = 20,
  }) async {
    if (lastestOrderBy != orderBy) {
      vods.clear();
      publisherVods.clear();
      publisherVods = [BlockVod([], 0)];
    }
    if (orderBy == 0) {
      var res = await Get.find<PublisherProvider>().getManyLatestVodBy(
        page: page,
        limit: limit,
        publisherId: publisherId,
        // order: key,
      );
      publisherVods = [res];
      vods.addAll(res.vods);
    } else {
      var res = await Get.find<PublisherProvider>().getManyHottestVodBy(
        page: page,
        limit: limit,
        publisherId: publisherId,
        // order: key,
      );
      publisherVods = [res];
      vods.addAll(res.vods);
    }
    lastestOrderBy = orderBy;
    update();
  }
}
