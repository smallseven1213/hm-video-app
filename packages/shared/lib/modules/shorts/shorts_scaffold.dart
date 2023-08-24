import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:shared/controllers/pageview_index_controller.dart';
import 'package:get/get.dart';
import 'package:shared/models/vod.dart';

import '../../controllers/ui_controller.dart';
import '../../utils/screen_control.dart';

class ShortsScaffold extends StatefulWidget {
  final Function() createController;
  final String uuid;
  final int? videoId;
  final int? itemId;
  final bool? useCachedList;
  final bool? displayFavoriteAndCollectCount;
  final Widget? loadingWidget;
  final Function()? onScrollBeyondFirst;
  final Function(
      {required int index,
      required bool isActive,
      required Vod shortData,
      required Function toggleFullScreen}) shortCardBuilder;

  const ShortsScaffold({
    required this.createController,
    this.videoId,
    this.itemId,
    required this.uuid,
    this.displayFavoriteAndCollectCount = true,
    this.useCachedList = false,
    this.loadingWidget,
    this.onScrollBeyondFirst,
    required this.shortCardBuilder,
    Key? key,
  }) : super(key: key);

  @override
  ShortsScaffoldState createState() => ShortsScaffoldState();
}

class ShortsScaffoldState extends State<ShortsScaffold> {
  bool isInitial = false;
  // PreloadPageController? _pageController;
  PageController? _pageController;
  int currentPage = 0;
  List<Vod> cachedVods = [];
  final PageViewIndexController pageviewIndexController =
      Get.find<PageViewIndexController>();
  final UIController uiController = Get.find<UIController>();

  @override
  void initState() {
    super.initState();

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
    });

    cachedVods = controller.data;

    if (widget.useCachedList == false) {
      ever(controller.data, (d) {
        if (isInitial == false && mounted) {
          // set _pageController index to 0
          // _pageController?.jumpToPage(0);
          setState(() {
            isInitial = true;
            cachedVods = d as List<Vod>;
          });
        }
      });
    }

    currentPage = initialPageIndex;
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
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          if (cachedVods.isEmpty)
            Center(
              child: widget.loadingWidget,
            ),
          NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification notification) {
              if (notification is ScrollStartNotification) {
                accumulatedScroll = 0.0;
                hasTriggered = false;
              } else if (notification is ScrollUpdateNotification &&
                  currentPage == 0 &&
                  !hasTriggered) {
                print(notification.scrollDelta);
                accumulatedScroll += notification.scrollDelta!;
                // 检查滚动的实际方向是否为向上
                if (accumulatedScroll > 0 && accumulatedScroll >= 30.0) {
                  widget.onScrollBeyondFirst?.call();
                  hasTriggered = true;
                  // 重置累积距离，以避免多次触发
                  accumulatedScroll = 0.0;
                }
              }
              return true;
            },
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (int index) {
                if (mounted) {
                  setState(() {
                    currentPage = index;
                  });
                }
              },
              // preloadPagesCount: 2,
              itemCount: cachedVods.length * 50,
              itemBuilder: (BuildContext context, int index) {
                var currentIndex = index % cachedVods.length;
                var shortData = cachedVods[currentIndex];
                bool isItemActive = index == currentPage;
                return widget.shortCardBuilder(
                  index: index,
                  shortData: shortData,
                  isActive: isItemActive,
                  toggleFullScreen: () {
                    toggleFullScreen();
                  },
                );
              },
              scrollDirection: Axis.vertical,
            ),
          ),
        ],
      ),
    );
  }
}
