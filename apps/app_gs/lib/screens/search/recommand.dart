import 'package:app_gs/localization/i18n.dart';
import 'package:app_gs/screens/search/tag_item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/tag_popular_controller.dart';
import 'package:shared/controllers/video_popular_controller.dart';
import 'package:shared/controllers/user_search_history_controller.dart';

import '../../widgets/header.dart';
import '../../widgets/video_preview.dart';

class RecommandScreen extends StatefulWidget {
  final Function onClickTag;

  const RecommandScreen({Key? key, required this.onClickTag}) : super(key: key);

  @override
  RecommandScreenState createState() => RecommandScreenState();
}

class RecommandScreenState extends State<RecommandScreen> {
  late final TagPopularController tagPopularController;
  late final VideoPopularController videoPopularController;
  final UserSearchHistoryController userSearchHistoryController =
      Get.find<UserSearchHistoryController>();

  @override
  void initState() {
    super.initState();
    tagPopularController = Get.put(TagPopularController());
    videoPopularController = Get.find<VideoPopularController>();
  }

  @override
  void dispose() {
    Get.delete<TagPopularController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: kIsWeb ? null : const BouncingScrollPhysics(),
      slivers: <Widget>[
        Obx(() {
          if (userSearchHistoryController.searchHistory.isEmpty) {
            return const SliverToBoxAdapter(
              child: SizedBox.shrink(),
            );
          }
          return SliverToBoxAdapter(
            child: Header(
                text: I18n.searchRecord,
                // moreButton is a Button from Image AssetImage
                moreButton: GestureDetector(
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
                              widget.onClickTag(keyword);
                            }))
                        .toList()
                        .cast<Widget>(),
                  ),
                ),
              ]),
            ),
          );
        }),
        SliverToBoxAdapter(child: Header(text: I18n.searchRecommendation)),
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
                              widget.onClickTag(tag.name);
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
        SliverToBoxAdapter(child: Header(text: I18n.recommended)),
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
                              displayVideoFavoriteTimes: false,
                              videoFavoriteTimes:
                                  firstVideo.videoFavoriteTimes!,
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
                                    videoViewTimes: secondVideo.videoViewTimes!,
                                    displayVideoFavoriteTimes: false,
                                    videoFavoriteTimes:
                                        secondVideo.videoFavoriteTimes!,
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
