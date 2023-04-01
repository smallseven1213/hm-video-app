import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared/apis/tag_api.dart';
import '../models/block_vod.dart';

final tagApi = TagApi();
const limit = 100;

class TagVideoController extends GetxController {
  final int id;
  late int page;
  final List<BlockVod> blocks = <BlockVod>[].obs;
  bool _hasReachedEnd = false;

  TagVideoController(this.id) {
    page = 1;
  }

  @override
  void onInit() async {
    super.onInit();
    fetchMoreVideos();
  }

  Future<void> fetchMoreVideos() async {
    if (_hasReachedEnd) return;

    var res = await tagApi.getRecommendVod(tagId: id, page: page, limit: limit);
    if (res.vods.isEmpty || res.vods.length < limit) {
      _hasReachedEnd = true;
    }

    if (res.vods.isNotEmpty) {
      blocks.add(res);
      page++;
    }
  }
}
