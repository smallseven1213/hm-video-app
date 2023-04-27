import 'package:app_gs/screens/video/video_actions.dart';
import 'package:app_gs/screens/video/video_list.dart';
import 'package:app_gs/widgets/tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/block_videos_by_category_controller.dart';
import 'package:shared/models/index.dart';

import 'video_info.dart';

class NestedTabBarView extends StatelessWidget {
  final Vod videoDetail;
  final Video videoBase;
  const NestedTabBarView({
    Key? key,
    required this.videoDetail,
    required this.videoBase,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> tabs =
        videoDetail.actors!.isEmpty ? ['同類型', '同標籤'] : ['同演員', '同類型', '同標籤'];
    String getIdList(List inputList) {
      if (inputList.isEmpty) return '';
      return inputList.take(3).map((e) => e.id.toString()).join(',');
    }

    final BlockVideosByCategoryController blockVideosController = Get.put(
      BlockVideosByCategoryController(
        tagId: getIdList(videoDetail.tags!),
        actorId: videoDetail.actors!.isEmpty
            ? ''
            : videoDetail.actors![0].id.toString(),
        excludeId: videoDetail.id.toString(),
        internalTagId: videoDetail.internalTagIds!.join(',').toString(),
      ),
      tag: DateTime.now().toString(),
    );

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
                      title: videoDetail.title,
                      tags: videoDetail.tags ?? [],
                      timeLength: videoDetail.timeLength ?? 0,
                      viewTimes: videoDetail.videoViewTimes ?? 0,
                      actor: videoDetail.actors,
                      publisher: videoDetail.publisher,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: VideoActions(
                      videoBase: videoBase,
                      videoDetail: videoDetail,
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
                          Obx(() {
                            var videos =
                                blockVideosController.videoByActor.value;
                            switch (name) {
                              case '同類型':
                                videos = blockVideosController.videoByTag.value;
                                break;
                              case '同標籤':
                                videos = blockVideosController
                                    .videoByInternalTag.value;
                                break;
                              case '同演員':
                                videos =
                                    blockVideosController.videoByActor.value;
                                break;
                            }
                            if (videos.isEmpty) {
                              return const SliverToBoxAdapter(
                                child: SizedBox(
                                  height: 300,
                                  child: Center(
                                    child: Text(
                                      '沒有相關影片',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              );
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
