import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../models/infinity_vod.dart';
import '../models/vod.dart';

final logger = Logger();

abstract class BaseVodInfinityScrollController extends GetxController {
  RxList<Vod> vodList = <Vod>[].obs;
  bool hasInitial = false;
  final page = 0.obs;
  final totalCount = 0.obs;
  RxBool showNoMore = false.obs;
  Timer? _timer;
  RxBool hasMoreData = false.obs;
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
    showNoMore.value = false;
  }

  Future<void> loadMoreData() async {
    if (!hasMoreData.value && hasInitial) return;

    int nextPage = page.value + 1;
    InfinityVod newData = await fetchData(nextPage);

    if (newData.vods.isNotEmpty) {
      vodList.addAll(newData.vods);
      page.value = nextPage;
      totalCount.value = vodList.length;
      hasMoreData.value = newData.hasMoreData;
    } else {
      hasMoreData.value = false;
    }
    hasInitial = true;
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
        !hasMoreData.value &&
        !showNoMore.value) {
      Future.delayed(const Duration(milliseconds: 5), () {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
      showNoMore.value = true;
      _startTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 3), () {
      showNoMore.value = false;
    });
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
