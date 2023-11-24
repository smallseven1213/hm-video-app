import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared/controllers/pageview_index_controller.dart';
import 'package:get/get.dart';
import 'package:shared/models/vod.dart';

import '../../controllers/ui_controller.dart';
import '../../controllers/video_short_ads_controller.dart';
import '../../models/banner_photo.dart';
import '../../utils/screen_control.dart';

class ShortsScaffold extends StatefulWidget {
  final Function() createController;
  final String uuid;
  final int? videoId;
  final int? itemId;
  final bool? useCachedList;
  final bool? displayFavoriteAndCollectCount;
  final Widget? loadingWidget;
  final Widget Function(String refreshkey)? refreshIndicatorWidget;
  final Function()? onScrollBeyondFirst;
  final Function(
      {required int index,
      required bool isActive,
      required Vod shortData,
      required Function toggleFullScreen}) shortCardBuilder;
  final Function({
    required BannerPhoto ad,
  })? playingAdBuilder;

  const ShortsScaffold({
    required this.createController,
    this.videoId,
    this.itemId,
    required this.uuid,
    this.displayFavoriteAndCollectCount = true,
    this.useCachedList = false,
    this.loadingWidget,
    this.onScrollBeyondFirst,
    this.refreshIndicatorWidget,
    this.playingAdBuilder,
    required this.shortCardBuilder,
    Key? key,
  }) : super(key: key);

  @override
  ShortsScaffoldState createState() => ShortsScaffoldState();
}

class ShortsScaffoldState extends State<ShortsScaffold> {
  // final RefreshController _refreshController =
  //     RefreshController(initialRefresh: false);

  bool isLoading = false;
  PageController? _pageController;
  int currentPage = 0;
  List<dynamic> cachedVods = [];
  final PageViewIndexController pageviewIndexController =
      Get.find<PageViewIndexController>();
  final UIController uiController = Get.find<UIController>();
  String refreshIndicatorWidgetKey = '';
  final ShortVideoAdsController shortVideoAdsController =
      Get.find<ShortVideoAdsController>();
  List<BannerPhoto> shortVideoAds = [];

  @override
  void initState() {
    super.initState();
    initShorts().then((_) => updateAds());
    setupAdsListener();
  }

  Future<void> initShorts() async {
    final controller = widget.createController();
    int initialPageIndex =
        controller.data.indexWhere((data) => data.id == widget.videoId);
    if (initialPageIndex == -1) {
      initialPageIndex = 0;
    }

    // 如果getx有值，就用getx的值
    var keyuuid = widget.uuid;

    if (pageviewIndexController.pageIndexes[keyuuid] != null) {
      initialPageIndex = pageviewIndexController.pageIndexes[keyuuid]!;
    }

    _pageController?.dispose();
    // _pageController = PreloadPageController(initialPage: initialPageIndex);
    _pageController = PageController(initialPage: initialPageIndex);

    _pageController?.addListener(() {
      pageviewIndexController.setPageIndex(
          keyuuid, _pageController?.page!.round() ?? 0);
      setState(() {
        currentPage = _pageController?.page!.round() ?? 0;
      });
    });

    cachedVods = controller.data;

    if (widget.useCachedList == false) {
      ever(controller.data, (d) {
        setState(() {
          cachedVods = d as List<Vod>;
        });
        updateAds();
      });
    }

    currentPage = initialPageIndex;
  }

  void setupAdsListener() {
    ever(shortVideoAdsController.videoAds, (_) => updateAds());
  }

  void updateAds() {
    if (widget.playingAdBuilder == null) return;
    // 獲取最新的廣告數據
    List<BannerPhoto> newAds =
        shortVideoAdsController.videoAds.value.shortPlayingAds ?? [];

    if (newAds.isNotEmpty) {
      shortVideoAds = newAds;
      List<dynamic> newCachedVods = [];
      int adIndex = 0;

      for (int i = 0; i < cachedVods.length; i++) {
        newCachedVods.add(cachedVods[i]);
        if ((i + 1) % 2 == 0 && i != cachedVods.length - 1) {
          newCachedVods.add(shortVideoAds[adIndex]);
          adIndex = (adIndex + 1) % shortVideoAds.length;
        }
      }

      setState(() {
        cachedVods = newCachedVods;
      });
    }
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  void toggleFullScreen() {
    uiController.isFullscreen.value = !uiController.isFullscreen.value;
    if (uiController.isFullscreen.value) {
      setScreenLandScape();
      uiController.setDisplay(false);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: [
        SystemUiOverlay.bottom,
      ]);

      uiController.setDisplay(true);
    }
  }

  double accumulatedScroll = 0.0;
  bool hasTriggered = false;

  @override
  Widget build(BuildContext context) {
    // 创建一个通用的 PageView.builder
    Widget pageView = PageView.builder(
      controller: _pageController,
      itemCount: cachedVods.length,
      onPageChanged: (int index) {
        setState(() {
          currentPage = index;
        });
      },
      itemBuilder: (BuildContext context, int index) {
        if (cachedVods[index] is BannerPhoto &&
            widget.playingAdBuilder != null) {
          return widget.playingAdBuilder!(ad: cachedVods[index]);
        }
        return widget.shortCardBuilder(
          index: index,
          shortData: cachedVods[index],
          isActive: index == currentPage,
          toggleFullScreen: () {
            toggleFullScreen();
          },
        );
      },
      scrollDirection: Axis.vertical,
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: widget.onScrollBeyondFirst != null
          ? RefreshIndicator(
              onRefresh: () async {
                widget.onScrollBeyondFirst?.call();
                // 您可以添加一个延时或其他异步操作来模拟数据刷新
                // await Future.delayed(Duration(milliseconds: 800));
                // setState(() {
                //   refreshIndicatorWidgetKey = Uuid().v4();
                // });
              },
              child: pageView,
            )
          : pageView,
    );
  }
}
