import 'package:app_gs/screens/search/tag_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/tag_popular_controller.dart';
import 'package:shared/controllers/video_popular_controller.dart';
import 'package:shared/controllers/user_search_history_controller.dart';

import '../../widgets/header.dart';
import '../../widgets/video_preview.dart';

class RecommandScreen extends StatelessWidget {
  final Function onClickTag;

  RecommandScreen({Key? key, required this.onClickTag}) : super(key: key);

  final TagPopularController tagPopularController = Get.find();
  final VideoPopularController videoPopularController = Get.find();
  final UserSearchHistoryController userSearchHistoryController = Get.find();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: <Widget>[
        Obx(() {
          if (userSearchHistoryController.searchHistory.isEmpty) {
            return const SliverToBoxAdapter(
              child: SizedBox.shrink(),
            );
          }
          return SliverToBoxAdapter(
            child: Header(
                text: '搜索紀錄',
                // moreButton is a Button from Image AssetImage
                moreButton: InkWell(
                  onTap: () {
                    userSearchHistoryController.clear();
                  },
                  child: Image.asset(
                    'assets/images/search_delete.png',
                    width: 20,
                    height: 20,
                  ),
                )),
          );
        }),
        Obx(() {
          if (userSearchHistoryController.searchHistory.isEmpty) {
            return const SliverToBoxAdapter(
              child: SizedBox.shrink(),
            );
          }
          return SliverPadding(
            padding: const EdgeInsets.only(bottom: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    spacing: 8, // 標籤之間的水平間距
                    runSpacing: 8, // 標籤之間的垂直間距
                    children: userSearchHistoryController.searchHistory
                        .map((keyword) => TagItem(
                            tag: '#$keyword',
                            onTap: () {
                              onClickTag(keyword);
                            }))
                        .toList()
                        .cast<Widget>(),
                  ),
                ),
              ]),
            ),
          );
        }),
        const SliverToBoxAdapter(
          child: Header(
            text: '搜索推薦',
          ),
        ),
        Obx(() => SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    spacing: 8, // 標籤之間的水平間距
                    runSpacing: 8, // 標籤之間的垂直間距
                    children: tagPopularController.data
                        .map((tag) => TagItem(
                            tag: '#${tag.name}',
                            onTap: () {
                              onClickTag(tag.name);
                            }))
                        .toList()
                        .cast<Widget>(),
                  ),
                ),
              ]),
            )),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 20,
          ),
        ),
        const SliverToBoxAdapter(
          child: Header(
            text: '熱門推薦',
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 10,
          ),
        ),
        Obx(() => SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    var firstVideo = videoPopularController.data[index * 2];
                    var secondVideo =
                        (index * 2 + 1 < videoPopularController.data.length)
                            ? videoPopularController.data[index * 2 + 1]
                            : null;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: VideoPreviewWidget(
                              id: firstVideo.id,
                              coverVertical: firstVideo.coverVertical!,
                              coverHorizontal: firstVideo.coverHorizontal!,
                              timeLength: firstVideo.timeLength!,
                              tags: firstVideo.tags!,
                              title: firstVideo.title,
                              displayVideoTimes: true,
                              displayViewTimes: true,
                              videoViewTimes: firstVideo.videoViewTimes!,
                              videoCollectTimes: firstVideo.videoCollectTimes!,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: secondVideo != null
                                ? VideoPreviewWidget(
                                    id: secondVideo.id,
                                    coverVertical: secondVideo.coverVertical!,
                                    coverHorizontal:
                                        secondVideo.coverHorizontal!,
                                    timeLength: secondVideo.timeLength!,
                                    tags: secondVideo.tags!,
                                    title: secondVideo.title,
                                    displayVideoTimes: true,
                                    displayViewTimes: true,
                                    videoViewTimes: secondVideo.videoViewTimes!,
                                    videoCollectTimes:
                                        secondVideo.videoCollectTimes!,
                                  )
                                : const SizedBox(),
                          ),
                        ],
                      ),
                    );
                  },
                  childCount: (videoPopularController.data.length / 2).ceil(),
                ),
              ),
            ))
      ],
    );
  }
}
