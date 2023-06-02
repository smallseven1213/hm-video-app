import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/short_video_detail_controller.dart';
import 'package:shared/controllers/user_favorites_short_controlle.dart';
import 'package:shared/controllers/user_short_collection_controller.dart';
import 'package:shared/models/vod.dart';
import 'package:logger/logger.dart';
import 'package:shared/widgets/float_page_back_button.dart';
import 'package:shared/widgets/short_vod_provider.dart';

import '../screens/short/button.dart';
import 'shortcard/index.dart';
import 'short_bottom_area.dart';

final logger = Logger();

class BaseShortPage extends StatefulWidget {
  final Function() createController;
  final int videoId;
  final int itemId; // areaId, tagId, supplierId
  final bool? supportedPlayRecord;

  const BaseShortPage(
      {required this.createController,
      required this.videoId,
      required this.itemId,
      this.supportedPlayRecord = true,
      Key? key})
      : super(key: key);

  @override
  BaseShortPageState createState() => BaseShortPageState();
}

class BaseShortPageState extends State<BaseShortPage> {
  PageController? _pageController;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();

    final controller = widget.createController();
    int initialPageIndex =
        controller.data.indexWhere((data) => data.id == widget.videoId);
    if (initialPageIndex == -1) {
      initialPageIndex = 0;
    }

    _pageController = PageController(initialPage: initialPageIndex);
    currentPage = initialPageIndex;
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.createController();

    return Scaffold(
      body: Stack(
        children: [
          Obx(() {
            return PageView.builder(
              controller: _pageController,
              itemCount: controller.data.length * 50,
              onPageChanged: (int index) {
                setState(() {
                  currentPage = index;
                });
              },
              itemBuilder: (BuildContext context, int index) {
                var currentIndex = index % controller.data.length;
                var shortData = controller.data[currentIndex];
                return ShortVodProvider(
                  vodId: shortData.id,
                  child: Column(
                    children: [
                      Expanded(
                          child: ShortCard(
                              index: index,
                              id: shortData.id,
                              title: shortData.title,
                              supportedPlayRecord: widget.supportedPlayRecord)),
                      ShortBottomArea(
                        shortData: shortData,
                      ),
                    ],
                  ),
                );
              },
              scrollDirection: Axis.vertical,
            );
          }),
          const FloatPageBackButton()
        ],
      ),
    );
  }
}
