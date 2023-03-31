// VideoScreen stateless
import 'dart:math';

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
import 'package:shared/models/color_keys.dart';
import 'package:shared/models/index.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/widgets/sliver_header_delegate.dart';

import '../../widgets/video_preview.dart';

final logger = Logger();

enum LikeButtonType { favorite, bookmark }

enum VideoFilterType { actor, category, tag }

class VideoInfo extends StatelessWidget {
  final String title;
  final List<Tag> tags;

  const VideoInfo({
    super.key,
    required this.title,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    logger.i('tags: $tags');
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
        Wrap(
          spacing: 4,
          runSpacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: tags.map((tag) {
            return InkWell(
              onTap: () {
                // 點擊事件，帶入tag.id進入查詢頁
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

// create a IconButton widget with stateful
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
    logger.i('LikeButton init');

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
  Actions({super.key, required this.video});

  final userCollectionController = Get.find<UserCollectionController>();
  final userFavoritesVideoController = Get.find<UserFavoritesVideoController>();

  @override
  Widget build(BuildContext context) {
    logger.i('Actions init');

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
                  userFavoritesVideoController.removeVideo([video.id]);
                } else {
                  userFavoritesVideoController.addVideo(video);
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
                  userCollectionController.removeVideo([video.id]);
                } else {
                  userCollectionController.addVideo(video);
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

class RelatedVideosHeader extends StatelessWidget {
  final TabController tabController;

  const RelatedVideosHeader({
    super.key,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.colors[ColorKeys.background],
      padding: const EdgeInsets.only(bottom: 8),
      child: Align(
        child: SizedBox(
          width: 230,
          child: TabBar(
            controller: tabController,
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

    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
      child: Obx(
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
      ),
    );
  }
}

// change _buildVideoList to a stateless widget named VideoList and has props tabController and videoData
class VideoList extends StatelessWidget {
  final List<Vod> videos;
  final VideoFilterType category;
  final TabController tabController;

  const VideoList({
    super.key,
    required this.videos,
    required this.category,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    logger.i('VideoList init: $videos');

    return GridView.builder(
      scrollDirection: Axis.vertical,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 182 / 143,
      ),
      itemCount: videos.length,
      itemBuilder: (context, index) => VideoPreviewWidget(
        id: videos[index].id,
        title: videos[index].title,
        tags: videos[index].tags ?? [],
        timeLength: videos[index].timeLength ?? 0,
        coverHorizontal: videos[index].coverHorizontal ?? '',
        coverVertical: videos[index].coverVertical ?? '',
        videoViewTimes: videos[index].videoViewTimes ?? 0,
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
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _video = fetchVideoDetail();
    _tabController = TabController(length: 3, vsync: this);
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
              return CustomScrollView(
                slivers: [
                  VideoPlayerArea(id: widget.id, name: widget.name),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              VideoInfo(
                                title: snapshot.data!.title,
                                tags: snapshot.data!.tags ?? [],
                              ),
                              Actions(
                                video: snapshot.data!,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: SliverHeaderDelegate(
                      minHeight: 50.0,
                      maxHeight: 50.0,
                      child: RelatedVideosHeader(
                        tabController: _tabController,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height - 235,
                      ),
                      child: RelatedVideos(
                        tabController: _tabController,
                        videoData: snapshot.data!,
                      ),
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            // By default, show a loading spinner.
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

// 同類型 (internalTagId) 帶空取全部、取前面最多三個
// {{public_host}}/internalTags/internalTag/views?excludeId=3439&internalTagId=187
// » 同分類（internalTag），排除這筆影片，隨機 10 筆。（不看觀看次數）

// 同標籤 (tag) tagId 帶空取全部、取前面最多三個
// {{public_host}}/tags/tag/views?tagId=250&excludeId=4192
// » 同分類（tag），排除這筆影片，隨機 10 筆。（不看觀看次數）

// 同演員 actor id[0]
// {{public_host}}/videos/video/sameActors?actorId=1,2,3
// » 同分類（tag），排除這筆影片，隨機 10 筆。（不看觀看次數）
