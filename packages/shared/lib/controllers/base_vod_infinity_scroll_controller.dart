import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../models/infinity_vod.dart';
import '../models/vod.dart';

final logger = Logger();

abstract class BaseVodInfinityScrollController extends GetxController {
  final vodList = <Vod>[].obs;
  final page = 0.obs;
  final totalCount = 0.obs;
  RxBool showNoMore = false.obs;
  Timer? _timer;
  RxBool isLoading = false.obs;
  RxBool hasMoreData = true.obs;
  ScrollController scrollController = ScrollController();

  BaseVodInfinityScrollController(
      {bool loadDataOnInit = true,
      required ScrollController scrollController}) {
    // this.scrollController = scrollController;
    this.scrollController.addListener(_scrollListener);
    if (loadDataOnInit) {
      loadMoreData();
    }
  }

  Future<InfinityVod> fetchData(int page);

  void reset() {
    vodList.clear();
    page.value = 0;
    totalCount.value = 0;
    hasMoreData.value = true;
    showNoMore.value = false;
  }

  Future<void> loadMoreData() async {
    if (isLoading.value || !hasMoreData.value) return;
    isLoading.value = true;

    int nextPage = page.value + 1;
    InfinityVod newData = await fetchData(nextPage);
    logger.i(newData.vods.isNotEmpty);

    if (newData.vods.isNotEmpty) {
      vodList.addAll(newData.vods);
      page.value = nextPage;
      totalCount.value = vodList.length;
      hasMoreData.value = newData.hasMoreData;
    } else {
      hasMoreData.value = false;
    }

    isLoading.value = false;
  }

  void _scrollListener() {
    logger.i('XD');
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      loadMoreData();
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
    scrollController.dispose();
    _timer?.cancel();
    super.onClose();
  }
}
