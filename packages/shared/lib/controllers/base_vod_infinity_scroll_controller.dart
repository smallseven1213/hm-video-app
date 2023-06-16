import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../models/infinity_vod.dart';
import '../models/vod.dart';

final logger = Logger();

abstract class BaseVodInfinityScrollController extends GetxController {
  var vodList = <Vod>[].obs;
  var isLoading = false.obs;
  var isListEmpty = false.obs;
  var hasMoreData = false.obs;
  var displayNoMoreData = false.obs;
  var displayLoading = true.obs;
  final page = 0.obs;
  final offset = 1.obs;
  final totalCount = 0.obs;
  Timer? _timer;
  late final ScrollController scrollController;
  late bool _autoDisposeScrollController = true;
  late bool _hasLoadMoreEventWithScroller = true;
  Timer? _debounceTimer;

  BaseVodInfinityScrollController(
      {bool loadDataOnInit = true,
      bool autoDisposeScrollController = true,
      bool hasLoadMoreEventWithScroller = true,
      required ScrollController customScrollController}) {
    scrollController = customScrollController;
    _autoDisposeScrollController = autoDisposeScrollController;
    _hasLoadMoreEventWithScroller = hasLoadMoreEventWithScroller;
    if (_hasLoadMoreEventWithScroller) {
      scrollController.addListener(_scrollListener);
    }
    if (loadDataOnInit) {
      loadMoreData();
    }
  }

  Future<InfinityVod> fetchData(int page);

  void reset() {
    vodList.clear();
    page.value = 0;
    totalCount.value = 0;
    hasMoreData.value = false;
  }

  Future<void> _fetchData({bool refresh = false}) async {
    if (!hasMoreData.value && vodList.isNotEmpty) return;
    isLoading.value = true;

    int nextPage;
    if (refresh) {
      offset.value = offset.value <= 5 ? offset.value + 1 : 1;
      nextPage = offset.value;
    } else {
      nextPage = page.value + 1;
    }

    InfinityVod newData = await fetchData(nextPage);
    List<Vod> newVods = newData.vods;

    if (newVods.isNotEmpty) {
      if (refresh) {
        vodList.value = newVods; // 替換現有的列表
      } else {
        vodList.addAll(newVods); // 加入到現有的列表
      }
      page.value = nextPage;
      totalCount.value = vodList.length;
      hasMoreData.value = newData.hasMoreData;
    } else {
      hasMoreData.value = false;
    }

    isListEmpty.value = vodList.isEmpty;
    isLoading.value = false;
    displayNoMoreData.value =
        !isLoading.value && !hasMoreData.value && !isListEmpty.value;
    displayLoading.value = hasMoreData.value || isLoading.value;
  }

  // 下拉更新
  Future<void> pullToRefresh() async {
    _fetchData(refresh: true);
  }

  // 下滑取得更多
  Future<void> loadMoreData() async {
    _fetchData(refresh: false);
  }

  void debounce({required Function() fn, int waitForMs = 200}) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(Duration(milliseconds: waitForMs), fn);
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      debounce(
        fn: () {
          loadMoreData();
        },
      );
    }

    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        !hasMoreData.value) {
      Future.delayed(const Duration(milliseconds: 5), () {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  void onClose() {
    scrollController.removeListener(_scrollListener);
    if (_autoDisposeScrollController == true) {
      scrollController.dispose();
    }
    _timer?.cancel();
    _debounceTimer?.cancel();
    super.onClose();
  }
}
