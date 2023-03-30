// VideoScreen stateless
import 'dart:math';

import 'package:app_gp/config/colors.dart';
import 'package:app_gp/screens/video/video_player_area.dart';
import 'package:app_gp/widgets/button.dart';
import 'package:app_gp/widgets/glowing_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/block_videos_controller.dart';
import 'package:shared/controllers/user_favorites_video_controlle.dart';
import 'package:shared/controllers/user_video_collection_controller.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/models/index.dart';
import 'package:shared/widgets/sliver_header_delegate.dart';

enum LikeButtonType { favorite, bookmark }

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
    print('tags: $tags');
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
  bool isLiked = false;
  LikeButtonType type = LikeButtonType.favorite;

  @override
  void initState() {
    super.initState();
    isLiked = widget.isLiked;
    type = widget.type ?? LikeButtonType.favorite;
  }

  @override
  Widget build(BuildContext context) {
    IconData iconData = isLiked ? Icons.favorite : Icons.favorite_border;
    if (type == LikeButtonType.bookmark) {
      iconData = isLiked ? Icons.bookmark : Icons.bookmark_border;
    }
    return Button(
      text: widget.text,
      onPressed: () {
        setState(() {
          isLiked = !isLiked;
        });
        widget.onPressed();
      },
      icon: GlowingIcon(
        iconData: iconData,
        color: isLiked ? Colors.yellow.shade700 : Colors.white,
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Obx(() => LikeButton(
                text: '喜歡就點讚',
                isLiked: userFavoritesVideoController.videos
                    .contains(video.id.toString()),
                onPressed: () {
                  userFavoritesVideoController.addVideo(video);
                },
              )),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Obx(() => LikeButton(
                text: '收藏',
                type: LikeButtonType.bookmark,
                isLiked: userCollectionController.videos
                    .contains(video.id.toString()),
                onPressed: () {
                  userCollectionController.addVideo(video);
                },
              )),
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

  const RelatedVideosHeader({super.key, required this.tabController});

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

  const RelatedVideos({
    super.key,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
      child: TabBarView(
        controller: tabController,
        children: [
          _buildVideoList('同演員'),
          _buildVideoList('同類型'),
          _buildVideoList('同標籤'),
          // SliverAlignGrid
        ],
      ),
    );
  }

  Widget _buildVideoList(String category) {
    return GridView.builder(
      scrollDirection: Axis.vertical,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 182 / 143,
      ),
      itemCount: 10,
      itemBuilder: (context, index) => Container(
        color: Colors.blue,
        child: Center(child: Text('$category 影片 ${index + 1}')),
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
        body: CustomScrollView(
          slivers: [
            VideoPlayerArea(id: widget.id, name: widget.name),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FutureBuilder<Vod>(
                      future: _video,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Column(
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
                              // BannerAd(),
                              // ChannelAreaBanner(
                              //   image: block.banner!,
                              // ),
                            ],
                          );
                        } else if (snapshot.hasError) {
                          return Text('${snapshot.error}');
                        }

                        // By default, show a loading spinner.
                        return Center(child: CircularProgressIndicator());
                      },
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
                child: RelatedVideosHeader(tabController: _tabController),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height - 235,
                ),
                child: RelatedVideos(tabController: _tabController),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// 同類型 (excludeId) 帶空取全部、取前面最多三個
// {{public_host}}/internalTags/internalTag/views?excludeId=3439&internalTagId=187
// » 同分類（internalTag），排除這筆影片，隨機 10 筆。（不看觀看次數）

// 同標籤 (tag) tagId 帶空取全部、取前面最多三個
// {{public_host}}/tags/tag/views?tagId=250&excludeId=4192
// » 同分類（tag），排除這筆影片，隨機 10 筆。（不看觀看次數）

// 同演員 actor id[0]
// {{public_host}}/tags/tag/views?tagId=250&excludeId=4192
// » 同分類（tag），排除這筆影片，隨機 10 筆。（不看觀看次數）

