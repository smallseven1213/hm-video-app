import 'package:flutter/material.dart';
import 'package:shared/controllers/pageview_index_controller.dart';
import 'package:get/get.dart';
import 'package:shared/models/short_video_detail.dart';
import 'package:shared/models/vod.dart';
import 'package:logger/logger.dart';
import 'package:shared/widgets/video_provider.dart';

final logger = Logger();

class BaseShortPageBuilder extends StatefulWidget {
  final Function() createController;
  final String uuid;
  final int? videoId;
  final int? itemId; // areaId, tagId, supplierId
  final bool? supportedPlayRecord;
  final bool? useCachedList;
  final bool? displayFavoriteAndCollectCount;
  final Widget? loadingWidget;
  final Function(
      {required int index,
      required String obsKey,
      required Vod shortData,
      required Function toggleFullScreen}) shortCardBuilder;

  const BaseShortPageBuilder({
    required this.createController,
    this.videoId,
    this.itemId,
    required this.uuid,
    this.displayFavoriteAndCollectCount = true,
    this.supportedPlayRecord = true,
    this.useCachedList = false,
    this.loadingWidget,
    required this.shortCardBuilder,
    Key? key,
  }) : super(key: key);

  @override
  BaseShortPageBuilderState createState() => BaseShortPageBuilderState();
}

class BaseShortPageBuilderState extends State<BaseShortPageBuilder> {
  bool isInitial = false;
  PageController? _pageController;
  int currentPage = 0;
  List<Vod> cachedVods = [];
  final PageViewIndexController pageviewIndexController =
      Get.find<PageViewIndexController>();

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
    _pageController = PageController(initialPage: initialPageIndex);

    _pageController?.addListener(() {
      pageviewIndexController.setPageIndex(
          keyuuid, _pageController?.page!.round() ?? 0);
    });

    cachedVods = controller.data;

    if (widget.useCachedList == false) {
      ever(controller.data, (d) {
        if (isInitial == false) {
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
          PageView.builder(
            controller: _pageController,
            itemCount: cachedVods.length * 50,
            itemBuilder: (BuildContext context, int index) {
              var currentIndex = index % cachedVods.length;
              var shortData = cachedVods[currentIndex];
              String obsKey = '${widget.uuid}-${shortData.id.toString()}';
              return VideoProvider(
                  key: Key('video-provider-$obsKey'),
                  obsKey: obsKey,
                  vodId: shortData.id,
                  loading: Center(
                    child: widget.loadingWidget,
                  ),
                  child: widget.shortCardBuilder(
                    index: index,
                    obsKey: obsKey,
                    shortData: shortData,
                    toggleFullScreen: () =>
                        pageviewIndexController.toggleFullscreen(),
                  )
                  // child: ShortCard(
                  //     obsKey: obsKey.toString(),
                  //     index: index,
                  //     id: shortData.id,
                  //     title: shortData.title,
                  //     supportedPlayRecord: widget.supportedPlayRecord,
                  //     shortData: shortData,
                  //     displayFavoriteAndCollectCount:
                  //         widget.displayFavoriteAndCollectCount,
                  //     toggleFullScreen: () =>
                  //         pageviewIndexController.toggleFullscreen(),
                  //     hiddenBottomArea: widget.hiddenBottomArea),
                  );
            },
            scrollDirection: Axis.vertical,
          ),
        ],
      ),
    );
  }
}
