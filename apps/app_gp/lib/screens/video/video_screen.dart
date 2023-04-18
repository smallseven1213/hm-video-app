// VideoScreen stateless
import 'package:app_gp/config/colors.dart';
import 'package:app_gp/screens/video/video_player_area.dart';
import 'package:app_gp/widgets/button.dart';
import 'package:app_gp/widgets/glowing_icon.dart';
import 'package:app_gp/widgets/tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/block_videos_by_category_controller.dart';
import 'package:shared/controllers/user_favorites_video_controlle.dart';
import 'package:shared/controllers/user_video_collection_controller.dart';
import 'package:shared/controllers/video_detail_controller.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/models/index.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/widgets/video_time.dart';
import 'package:shared/widgets/view_times.dart';

import '../../widgets/custom_app_bar.dart';
import '../../widgets/video_preview.dart';

final logger = Logger();

enum LikeButtonType { favorite, bookmark }

enum VideoFilterType { actor, category, tag }

class NestedTabBarView extends StatelessWidget {
  final Vod videoDetail;
  const NestedTabBarView({
    Key? key,
    required this.videoDetail,
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
                    child: Actions(
                      video: videoDetail,
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

class VideoInfo extends StatelessWidget {
  final String title;
  final List<Tag> tags;
  final int timeLength;
  final int viewTimes;
  final List<Actor>? actor;
  final Publisher? publisher;

  const VideoInfo({
    super.key,
    required this.title,
    required this.tags,
    required this.timeLength,
    required this.viewTimes,
    this.actor,
    this.publisher,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        // 供應商、演員、觀看次數、時長
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (publisher != null || (actor != null && actor!.isNotEmpty))
                Expanded(
                  flex: 3,
                  child: Row(
                    children: [
                      if (publisher != null) ...[
                        InkWell(
                          onTap: () => MyRouteDelegate.of(context).push(
                            AppRoutes.vendorVideos.value,
                            args: {
                              'id': publisher!.id,
                              'title': publisher!.name
                            },
                            removeSamePath: true,
                          ),
                          child: Text(
                            publisher!.name,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xffC7C3C3),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        )
                      ],
                      if (actor != null && actor!.isNotEmpty)
                        InkWell(
                          onTap: () {
                            MyRouteDelegate.of(context).push(
                              AppRoutes.actor.value,
                              args: {
                                'id': actor![0].id,
                                'title': actor![0].name
                              },
                              removeSamePath: true,
                            );
                          },
                          child: Text(
                            actor![0].name,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xffC7C3C3),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              // const Spacer(),
              Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ViewTimes(
                        times: viewTimes,
                        color: const Color(0xffC7C3C3),
                      ),
                      VideoTime(
                        time: timeLength,
                        color: const Color(0xffC7C3C3),
                        hasIcon: true,
                      ),
                    ],
                  ))
            ],
          ),
        ),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: tags.map((tag) {
            return InkWell(
              onTap: () {
                MyRouteDelegate.of(context).push(AppRoutes.tag.value,
                    args: {'id': tag.id, 'title': tag.name});
              },
              child: Text(
                '#${tag.name}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF00B2FF),
                  letterSpacing: 0.1,
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class LikeButton extends StatefulWidget {
  final bool isLiked;
  final String text;
  final VoidCallback onPressed;
  final LikeButtonType? type;

  const LikeButton({
    Key? key,
    required this.isLiked,
    required this.onPressed,
    required this.text,
    this.type,
  }) : super(key: key);

  @override
  LikeButtonState createState() => LikeButtonState();
}

class LikeButtonState extends State<LikeButton> {
  LikeButtonType type = LikeButtonType.favorite;

  @override
  void initState() {
    super.initState();
    type = widget.type ?? LikeButtonType.favorite;
  }

  @override
  Widget build(BuildContext context) {
    IconData iconData = widget.isLiked ? Icons.favorite : Icons.favorite_border;
    if (type == LikeButtonType.bookmark) {
      iconData = widget.isLiked ? Icons.bookmark : Icons.bookmark_border;
    }
    return Button(
      text: widget.text,
      onPressed: () {
        widget.onPressed();
      },
      icon: GlowingIcon(
        iconData: iconData,
        color: widget.isLiked ? Colors.yellow.shade700 : Colors.white,
        size: 20,
      ),
    );
  }
}

class Actions extends StatelessWidget {
  final Vod video;
  final Vod videoDetail;
  Actions({super.key, required this.video, required this.videoDetail});

  final userCollectionController = Get.find<UserCollectionController>();
  final userFavoritesVideoController = Get.find<UserFavoritesVideoController>();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Obx(() {
            var isLiked = userFavoritesVideoController.videos
                .any((e) => e.id == video.id);
            return LikeButton(
              text: '喜歡就點讚',
              isLiked: isLiked,
              onPressed: () {
                if (isLiked) {
                  userFavoritesVideoController.removeVideo([videoDetail.id]);
                } else {
                  userFavoritesVideoController.addVideo(videoDetail);
                }
              },
            );
          }),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Obx(() {
            var isLiked =
                userCollectionController.videos.any((e) => e.id == video.id);
            return LikeButton(
              text: '收藏',
              type: LikeButtonType.bookmark,
              isLiked: isLiked,
              onPressed: () {
                if (isLiked) {
                  userCollectionController.removeVideo([videoDetail.id]);
                } else {
                  userCollectionController.addVideo(videoDetail);
                }
              },
            );
          }),
        ),
      ],
    );
  }
}

class BannerAd extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      color: Colors.orange,
      child: Center(child: Text('廣告 Banner', style: TextStyle(fontSize: 24))),
    );
  }
}

class RelatedVideos extends StatelessWidget {
  final TabController tabController;
  final Vod videoDetail;

  const RelatedVideos({
    super.key,
    required this.tabController,
    required this.videoDetail,
  });

  String getIdList(List inputList) {
    if (inputList.isEmpty) return '';
    return inputList.take(3).map((e) => e.id.toString()).join(',');
  }

  @override
  Widget build(BuildContext context) {
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

    return Obx(
      () {
        return TabBarView(
          controller: tabController,
          children: [
            VideoList(
              videos: blockVideosController.videoByActor.value,
              tabController: tabController,
              category: VideoFilterType.actor,
            ),
            VideoList(
              videos: blockVideosController.videoByTag.value,
              tabController: tabController,
              category: VideoFilterType.category,
            ),
            VideoList(
              videos: blockVideosController.videoByInternalTag.value,
              tabController: tabController,
              category: VideoFilterType.tag,
            ),
            // SliverAlignGrid
          ],
        );
      },
    );
  }
}

class VideoList extends StatelessWidget {
  final List<Vod> videos;
  final VideoFilterType? category;
  final TabController? tabController;

  const VideoList({
    super.key,
    required this.videos,
    this.category,
    this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAlignedGrid.count(
      crossAxisCount: 2,
      itemCount: videos.length,
      itemBuilder: (BuildContext context, int index) {
        var video = videos[index];
        return VideoPreviewWidget(
            id: video.id,
            coverVertical: video.coverVertical!,
            coverHorizontal: video.coverHorizontal!,
            timeLength: video.timeLength!,
            tags: video.tags!,
            title: video.title,
            videoViewTimes: video.videoViewTimes!);
      },
      mainAxisSpacing: 12.0,
      crossAxisSpacing: 10.0,
    );
  }
}

class VideoScreen extends StatefulWidget {
  final int id;
  final String? name;

  const VideoScreen({
    Key? key,
    required this.id,
    this.name,
  }) : super(key: key);

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoDetailController videoDetailController;

  @override
  void initState() {
    super.initState();
    getVideo();
  }

  void getVideo() async {
    videoDetailController =
        Get.put(VideoDetailController(widget.id), tag: widget.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Obx(
          () => videoDetailController.videoUrl.value != ''
              ? Column(
                  children: [
                    VideoPlayerArea(
                      id: widget.id,
                      name: widget.name,
                      videoUrl: videoDetailController.videoUrl.value,
                    ),
                    videoDetailController.videoDetail.value.id != 0
                        ? Expanded(
                            child: NestedTabBarView(
                              videoDetail:
                                  videoDetailController.videoDetail.value,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ],
                )
              : Column(
                  children: [
                    CustomAppBar(
                      title: widget.name ?? '',
                      backgroundColor: Colors.transparent,
                    ),
                    const Expanded(
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
