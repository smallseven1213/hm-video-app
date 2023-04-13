import 'package:get/get.dart';
import 'package:shared/models/channel_info.dart';

import '../apis/vod_api.dart';
import '../models/block_vod.dart';

final vodApi = VodApi();
const int limit = 96;

class BlockVideosController extends GetxController {
  final int id;
  late int page;
  final List<BlockVod> blocks = <BlockVod>[].obs;
  bool _hasReachedEnd = false;
  final isLoading = false.obs;

  BlockVideosController(this.id) {
    page = 1;
  }

  @override
  void onInit() async {
    super.onInit();
    fetchMoreVideos();
  }

  Future<void> fetchMoreVideos() async {
    if (_hasReachedEnd) return;

    isLoading.value = true;

    try {
      var res = await vodApi.getMoreMany(id, page: page, limit: limit);
      if (res.vods.isEmpty || res.vods.length < limit) {
        _hasReachedEnd = true;
      }

      if (res.vods.isNotEmpty) {
        blocks.add(res);
        page++;
      }
    } catch (e) {
      logger.e(e);
    } finally {
      isLoading.value = false;
    }
  }
}
