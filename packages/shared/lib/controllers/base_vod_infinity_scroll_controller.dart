import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../models/infinity_vod.dart';
import '../models/vod.dart';

abstract class BaseVodInfinityScrollController extends GetxController {
  final vodList = <Vod>[].obs;
  final page = 0.obs;
  final totalCount = 0.obs;
  bool isLoading = false;
  bool hasMoreData = true;
  ScrollController scrollController = ScrollController();

  BaseVodInfinityScrollController({bool loadDataOnInit = true}) {
    scrollController.addListener(_scrollListener);
    if (loadDataOnInit) {
      _loadMoreData();
    }
  }

  Future<InfinityVod> fetchData(int page);

  Future<void> _loadMoreData() async {
    if (isLoading || !hasMoreData) return;
    isLoading = true;

    int nextPage = page.value + 1;
    InfinityVod newData = await fetchData(nextPage);

    if (newData.vods.isNotEmpty) {
      vodList.addAll(newData.vods);
      page.value = nextPage;
      totalCount.value = vodList.length;
      hasMoreData = newData.hasMoreData;
    } else {
      hasMoreData = false;
    }

    isLoading = false;
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      _loadMoreData();
    }
  }

  @override
  void onClose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.onClose();
  }
}
