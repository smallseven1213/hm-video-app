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
  final Widget? noDataWidget;
  final Widget Function(String refreshkey)? refreshIndicatorWidget;
  final Function()? onScrollBeyondFirst;
  final Function(
      {required int index,
      required bool isActive,
      required Vod shortData,
      required Function toggleFullScreen}) shortCardBuilder;
  final Function({
    required BannerPhoto ad,
    required Vod? nextShortData,
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
    this.noDataWidget,
    Key? key,
  }) : super(key: key);

  @override
  ShortsScaffoldState createState() => ShortsScaffoldState();
}

class ShortsScaffoldState extends State<ShortsScaffold> {
  PageController? _pageController;
  int currentPage = 0;
  List<dynamic> cachedVods = [];
  final PageViewIndexController pageviewIndexController =
      Get.find<PageViewIndexController>();
  final UIController uiController = Get.find<UIController>();
  final ShortVideoAdsController shortVideoAdsController =
      Get.find<ShortVideoAdsController>();
  List<BannerPhoto> shortVideoAds = [];
  bool hasLoadedVideos = false; // 添加一個標誌來追踪是否曾經有過影片

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
    initialPageIndex = initialPageIndex == -1 ? 0 : initialPageIndex;
    var keyuuid = widget.uuid;
    if (pageviewIndexController.pageIndexes[keyuuid] != null) {
      initialPageIndex = pageviewIndexController.pageIndexes[keyuuid]!;
    }
    _pageController?.dispose();
    _pageController = PageController(initialPage: initialPageIndex);
    _pageController?.addListener(() {
      pageviewIndexController.setPageIndex(
          keyuuid, _pageController?.page!.round() ?? 0);
      if (mounted) {
        setState(() {
          currentPage = _pageController?.page!.round() ?? 0;
        });
      }
    });
    cachedVods = controller.data;
    if (cachedVods.isNotEmpty) {
      hasLoadedVideos = true; // 更新標誌
    }
    if (!widget.useCachedList!) {
      ever(controller.data, (d) {
        if (mounted) {
          setState(() {
            cachedVods = d as List<Vod>;
            if (cachedVods.isNotEmpty) {
              hasLoadedVideos = true;
            }
          });
        }
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
    List<BannerPhoto> newAds =
        shortVideoAdsController.videoAds.value.shortPlayingAds ?? [];
    if (newAds.isNotEmpty) {
      shortVideoAds = newAds;
      List<dynamic> newCachedVods = [];
      int adIndex = 0;
      int videoCount = 5;
      for (int i = 0; i < cachedVods.length; i++) {
        newCachedVods.add(cachedVods[i]);
        if ((i + 1) % videoCount == 0 && i != cachedVods.length - 1) {
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

  @override
  Widget build(BuildContext context) {
    // 检查是否有视频数据
    if (cachedVods.isEmpty && hasLoadedVideos) {
      if(widget.noDataWidget != null) {
        return widget.noDataWidget!;
      }
      // 暫時放個
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '没有更多视频',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // 返回上一页
                },
                child: Text('返回'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.yellow, // 文本色
                ),
              )
            ],
          ),
        ),
      );
    }

    Widget pageView = PageView.builder(
      controller: _pageController,
      itemCount: cachedVods.length,
      onPageChanged: (int index) {
        if (mounted) {
          setState(() {
            currentPage = index;
          });
        }
      },
      itemBuilder: (BuildContext context, int index) {
        if (cachedVods[index] is BannerPhoto &&
            widget.playingAdBuilder != null) {
          return widget.playingAdBuilder!(
            ad: cachedVods[index],
            nextShortData:
                index != cachedVods.length - 1 ? cachedVods[index + 1] : null,
          );
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
              },
              child: pageView,
            )
          : pageView,
    );
  }
}
