import 'package:app_gs/screens/video/nested_tab_bar_view/video_actions.dart';
import 'package:app_gs/screens/video/nested_tab_bar_view/video_list.dart';
import 'package:app_gs/widgets/no_data.dart';
import 'package:app_gs/widgets/tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/block_videos_by_category_controller.dart';
import 'package:shared/models/index.dart';

import 'app_download_ad.dart';
import 'banner.dart';
import 'video_info.dart';

class NestedTabBarView extends StatefulWidget {
  final Vod videoDetail;
  final Video videoBase;
  const NestedTabBarView({
    Key? key,
    required this.videoDetail,
    required this.videoBase,
  }) : super(key: key);

  @override
  _NestedTabBarViewState createState() => _NestedTabBarViewState();
}

class _NestedTabBarViewState extends State<NestedTabBarView> {
  late BlockVideosByCategoryController blockVideosController;

  @override
  void initState() {
    super.initState();
    blockVideosController = Get.put(
      BlockVideosByCategoryController(
        tagId: getIdList(widget.videoDetail.tags!),
        actorId: widget.videoDetail.actors!.isEmpty
            ? ''
            : widget.videoDetail.actors![0].id.toString(),
        excludeId: widget.videoDetail.id.toString(),
        internalTagId: widget.videoDetail.internalTagIds!.join(',').toString(),
      ),
      tag: DateTime.now().toString(),
    );
  }

  String getIdList(List inputList) {
    if (inputList.isEmpty) return '';
    return inputList.take(3).map((e) => e.id.toString()).join(',');
  }

  @override
  Widget build(BuildContext context) {
    final List<String> tabs = widget.videoDetail.actors!.isEmpty
        ? ['同類型', '同標籤']
        : ['同演員', '同類型', '同標籤'];

    return Padding(
        padding: const EdgeInsets.only(top: 0, left: 8, right: 8, bottom: 8),
        child: DefaultTabController(
          length: tabs.length, // This is the number of tabs.
          child: Scaffold(
            body: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                // These are the slivers that show up in the "outer" scroll view.
                return <Widget>[
                  SliverToBoxAdapter(
                    child: VideoInfo(
                      title: widget.videoDetail.title,
                      tags: widget.videoDetail.tags ?? [],
                      timeLength: widget.videoDetail.timeLength ?? 0,
                      viewTimes: widget.videoDetail.videoViewTimes ?? 0,
                      actor: widget.videoDetail.actors,
                      publisher: widget.videoDetail.publisher,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: VideoActions(
                      videoBase: widget.videoBase,
                      videoDetail: widget.videoDetail,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: AppDownloadAd(),
                  ),
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: VideoScreenBanner(),
                    ),
                  ),
                  SliverOverlapAbsorber(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context),
                    sliver: SliverAppBar(
                        pinned: true,
                        leading: null,
                        automaticallyImplyLeading: false,
                        forceElevated: innerBoxIsScrolled,
                        expandedHeight: 0,
                        toolbarHeight: 0,
                        flexibleSpace: const SizedBox.shrink(),
                        bottom: PreferredSize(
                            preferredSize: Size.fromHeight(60),
                            child: SizedBox(
                              height: 60,
                              child: GSTabBar(tabs: tabs),
                            ))),
                  ),
                ];
              },
              body: TabBarView(
                children: tabs.map((String name) {
                  print('name: $name');
                  return Builder(
                    builder: (BuildContext context) {
                      return CustomScrollView(
                        key: PageStorageKey<String>(name),
                        physics: const BouncingScrollPhysics(),
                        slivers: <Widget>[
                          SliverOverlapInjector(
                            handle:
                                NestedScrollView.sliverOverlapAbsorberHandleFor(
                                    context),
                          ),
                          if (name == '同類型' &&
                                  widget.videoDetail.internalTagIds!.isEmpty ||
                              name == '同標籤' && widget.videoDetail.tags!.isEmpty)
                            const SliverToBoxAdapter(
                              child: SizedBox(
                                height: 50,
                                child: Center(
                                  child: Text(
                                    '找不到相關影片，猜您也會喜歡',
                                    style: TextStyle(
                                      color: Color(0xff808c9f),
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          Obx(() {
                            var videos =
                                blockVideosController.videoByActor.value;
                            switch (name) {
                              case '同類型':
                                videos = blockVideosController
                                    .videoByInternalTag.value;
                                break;
                              case '同標籤':
                                videos = blockVideosController.videoByTag.value;
                                break;
                              case '同演員':
                                videos =
                                    blockVideosController.videoByActor.value;
                                break;
                            }
                            return SliverPadding(
                              padding: const EdgeInsets.only(bottom: 8),
                              sliver: VideoList(
                                videos: videos,
                              ),
                            );
                          }),
                        ],
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        ));
  }
}
