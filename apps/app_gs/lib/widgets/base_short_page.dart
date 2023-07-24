import 'package:flutter/material.dart';
import 'package:shared/controllers/pageview_index_controller.dart';
import 'package:get/get.dart';
import 'package:shared/models/vod.dart';
import 'package:logger/logger.dart';
import 'package:shared/widgets/video_provider.dart';

import 'shortcard/index.dart';
import 'wave_loading.dart';

final logger = Logger();

class BaseShortPage extends StatefulWidget {
  final Function() createController;
  final String uuid;
  final int? videoId;
  final int? itemId; // areaId, tagId, supplierId
  final bool? supportedPlayRecord;
  final bool? useCachedList;
  final bool? displayFavoriteAndCollectCount;
  final bool? hiddenBottomArea;
  final Map? floatBackRoute;

  const BaseShortPage({
    required this.createController,
    this.videoId,
    this.itemId,
    required this.uuid,
    this.displayFavoriteAndCollectCount = true,
    this.supportedPlayRecord = true,
    this.useCachedList = false,
    this.hiddenBottomArea = false,
    this.floatBackRoute,
    Key? key,
  }) : super(key: key);

  @override
  BaseShortPageState createState() => BaseShortPageState();
}

class BaseShortPageState extends State<BaseShortPage> {
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
            const Center(
              child: WaveLoading(
                color: Color.fromRGBO(255, 255, 255, 0.3),
                duration: Duration(milliseconds: 1000),
                size: 17,
                itemCount: 3,
              ),
            ),
          PageView.builder(
            controller: _pageController,
            itemCount: cachedVods.length * 50,
            // onPageChanged: (int index) {
            //   setState(() {
            //     currentPage = index;
            //   });
            // },
            itemBuilder: (BuildContext context, int index) {
              var currentIndex = index % cachedVods.length;
              var shortData = cachedVods[currentIndex];
              String obsKey = '${widget.uuid}-${shortData.id.toString()}';
              return VideoProvider(
                key: Key('video-provider-$obsKey'),
                obsKey: obsKey,
                vodId: shortData.id,
                loading: const Center(
                  child: WaveLoading(
                    color: Color.fromRGBO(255, 255, 255, 0.3),
                    duration: Duration(milliseconds: 1000),
                    size: 17,
                    itemCount: 3,
                  ),
                ),
                child: ShortCard(
                  obsKey: obsKey.toString(),
                  index: index,
                  id: shortData.id,
                  title: shortData.title,
                  supportedPlayRecord: widget.supportedPlayRecord,
                  shortData: shortData,
                  displayFavoriteAndCollectCount:
                      widget.displayFavoriteAndCollectCount,
                  toggleFullScreen: () =>
                      pageviewIndexController.toggleFullscreen(),
                  hiddenBottomArea: widget.hiddenBottomArea,
                  floatBackRoute: widget.floatBackRoute,
                ),
              );
            },
            scrollDirection: Axis.vertical,
          ),
        ],
      ),
    );
  }
}
