import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../models/infinity_vod.dart';
import '../models/vod.dart';

abstract class BaseVodInfinityScrollController extends GetxController {
  final vodList = <Vod>[].obs;
  final page = 0.obs;
  final totalCount = 0.obs;
  RxBool showNoMore = false.obs;
  Timer? _timer;
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

    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        !hasMoreData &&
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
