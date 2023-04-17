// VideoScreen stateless
import 'package:app_gp/config/colors.dart';
import 'package:app_gp/screens/video/video_player_area.dart';
import 'package:app_gp/widgets/button.dart';
import 'package:app_gp/widgets/glowing_icon.dart';
import 'package:flutter/material.dart';
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
import 'package:shared/utils/video_info_formatter.dart';
import 'package:shared/widgets/sliver_header_delegate.dart';
import 'package:shared/widgets/video_time.dart';
import 'package:shared/widgets/view_times.dart';

import '../../widgets/custom_app_bar.dart';
import '../../widgets/video_preview.dart';

final logger = Logger();

enum LikeButtonType { favorite, bookmark }

enum VideoFilterType { actor, category, tag }

class NestedTabBarView extends StatelessWidget {
  // final Widget header;
  final Vod? videoData;
  final Vod videoDetail;
  const NestedTabBarView({
    Key? key,
    // required this.header,
    this.videoData,
    required this.videoDetail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const tabs = ['同演員', '同類型', '同標籤'];
    String getIdList(List inputList) {
      if (inputList.isEmpty) return '';
      return inputList.take(3).map((e) => e.id.toString()).join(',');
    }

    final BlockVideosByCategoryController blockVideosController = Get.put(
      BlockVideosByCategoryController(
        tagId: getIdList(videoData!.tags!),
        actorId: videoData!.actors!.isEmpty
            ? ''
            : videoData!.actors![0].id.toString(),
        excludeId: videoData!.id.toString(),
        internalTagId: videoData!.internalTagIds!.join(',').toString(),
      ),
      tag: DateTime.now().toString(),
    );

    return DefaultTabController(
      length: tabs.length, // tab的數量.
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              // header,
              SliverToBoxAdapter(
                child: VideoInfo(
                  title: videoData!.title,
                  tags: videoData!.tags ?? [],
                  timeLength: videoData!.timeLength ?? 0,
                  viewTimes: videoData!.videoViewTimes ?? 0,
                  actor: videoData!.actors,
                  publisher: videoData!.publisher,
                ),
              ),
              SliverToBoxAdapter(
                child: Actions(
                  video: videoData!,
                  videoDetail: videoDetail,
                ),
              ),
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverPersistentHeader(
                  pinned: true,
                  delegate: SliverHeaderDelegate(
                    minHeight: 50.0,
                    maxHeight: 50.0,
                    child: const RelatedVideosHeader(),
                  ),
                ),
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
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context),
                      ),
                      Obx(() {
                        var videos = blockVideosController.videoByActor.value;
                        switch (name) {
                          case '同類型':
                            videos = blockVideosController.videoByTag.value;
                            break;
                          case '同標籤':
                            videos =
                                blockVideosController.videoByInternalTag.value;
                            break;
                          case '同演員':
                            videos = blockVideosController.videoByActor.value;
                            break;
                        }
                        if (videos.isEmpty) {
                          return const SliverToBoxAdapter(
                            child: SizedBox(
                              height: 200,
                              child: Center(
                                child: Text(
                                  '暫無數據',
                                  style: TextStyle(color: Colors.white),
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
    );
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
    logger.i('publisher: $publisher');
    logger.i('actor: $actor');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                  flex: 2,
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
                  flex: 1,
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

class RelatedVideosHeader extends StatelessWidget
    implements PreferredSizeWidget {
  const RelatedVideosHeader({
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.colors[ColorKeys.background],
      padding: const EdgeInsets.only(bottom: 8),
      child: Align(
        child: SizedBox(
          width: 230,
          child: TabBar(
            indicatorPadding: const EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 4,
            ),
            indicatorWeight: 5,
            indicatorColor: AppColors.colors[ColorKeys.primary],
            indicator: UnderlineTabIndicator(
              borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(10), right: Radius.circular(10)),
              borderSide: BorderSide(
                width: 5.0,
                color: AppColors.colors[ColorKeys.primary]!,
              ),
            ),
            tabs: const [
              Tab(text: '同演員'),
              Tab(text: '同類型'),
              Tab(text: '同標籤'),
            ],
          ),
        ),
      ),
    );
  }
}

class RelatedVideos extends StatelessWidget {
  final TabController tabController;
  final Vod videoData;

  const RelatedVideos({
    super.key,
    required this.tabController,
    required this.videoData,
  });

  String getIdList(List inputList) {
    if (inputList.isEmpty) return '';
    return inputList.take(3).map((e) => e.id.toString()).join(',');
  }

  @override
  Widget build(BuildContext context) {
    final BlockVideosByCategoryController blockVideosController = Get.put(
      BlockVideosByCategoryController(
        tagId: getIdList(videoData.tags!),
        actorId:
            videoData.actors!.isEmpty ? '' : videoData.actors![0].id.toString(),
        excludeId: videoData.id.toString(),
        internalTagId: videoData.internalTagIds!.join(',').toString(),
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
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 182 / 148,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return VideoPreviewWidget(
            id: videos[index].id,
            title: videos[index].title,
            tags: videos[index].tags ?? [],
            timeLength: videos[index].timeLength ?? 0,
            coverHorizontal: videos[index].coverHorizontal ?? '',
            coverVertical: videos[index].coverVertical ?? '',
            videoViewTimes: videos[index].videoViewTimes ?? 0,
          );
        },
        childCount: videos.length,
      ),
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

class _VideoScreenState extends State<VideoScreen>
    with SingleTickerProviderStateMixin {
  late Future<Vod> _video;
  // late TabController _tabController;
  late VideoDetailController videoDetailController;

  @override
  void initState() {
    super.initState();
    _video = fetchVideoDetail();
    // _tabController = TabController(length: 3, vsync: this);
    getVideoUrl();
  }

  void getVideoUrl() async {
    videoDetailController =
        Get.put(VideoDetailController(widget.id), tag: widget.id.toString());
  }

  Future<Vod> fetchVideoDetail() async => await vodApi.getVodDetail(widget.id);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder<Vod>(
          future: _video,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  Obx(
                    () => VideoPlayerArea(
                      id: widget.id,
                      name: widget.name,
                      videoUrl: videoDetailController.videoUrl.value,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: NestedTabBarView(
                        videoData: snapshot.data!,
                        videoDetail: videoDetailController.videoDetail.value,
                      ),
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            // By default, show a loading spinner.
            return Column(
              children: [
                CustomAppBar(
                  title: widget.name ?? '',
                  backgroundColor: Colors.transparent,
                ),
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
