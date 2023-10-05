import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared/apis/user_api.dart';
import 'package:shared/models/vod.dart';
import 'package:shared/modules/video/video_provider.dart';
import 'package:shared/modules/video_player/video_player_consumer.dart';
import 'package:shared/modules/video_player/video_player_provider.dart';
import 'package:shared/modules/videos/video_by_tag_consumer.dart';
import 'package:shared/utils/controller_tag_genarator.dart';
import '../screens/video/actors.dart';
import '../screens/video/app_download_ad.dart';
import '../screens/video/banner.dart';
import '../screens/video/belong_video.dart';
import '../screens/video/video_info.dart';
import '../screens/video/video_player_area/index.dart';
import '../screens/video/video_player_area/loading.dart';
import '../widgets/title_header.dart';
import '../widgets/video_preview.dart';
import '../widgets/wave_loading.dart';

final userApi = UserApi();

class Video extends StatefulWidget {
  final Map<String, dynamic> args;

  const Video({Key? key, required this.args}) : super(key: key);

  @override
  VideoState createState() => VideoState();
}

const gridRatio = 128 / 227;

class VideoState extends State<Video> {
  final ScrollController _controller = ScrollController();
  bool _showButton = false;
  // 為需要滾動到的部分添加GlobalKey
  final GlobalKey _belongVideoKey = GlobalKey(debugLabel: '_belongVideoKey');
  final GlobalKey _tagVideoKey = GlobalKey(debugLabel: '_tagVideoKey');

  @override
  void initState() {
    super.initState();
    // setScreenRotation();
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.black));

    _controller.addListener(() {
      if (_controller.offset > 100 && !_showButton) {
        setState(() {
          _showButton = true;
        });
      } else if (_controller.offset <= 100 && _showButton) {
        setState(() {
          _showButton = false;
        });
      }
    });
  }

  @override
  void dispose() {
    // setScreenPortrait();
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var id = int.parse(widget.args['id'].toString());
    final controllerTag = genaratorLongVideoDetailTag(id.toString());

    var name = widget.args['name'];
    return VideoScreenProvider(
      id: id,
      name: name,
      child: ({
        required String? videoUrl,
        required Vod? videoDetail,
      }) {
        if (videoUrl == null) {
          return const WaveLoading();
        }

        return SafeArea(
          child: Column(
            children: [
              VideoPlayerProvider(
                key: Key(videoUrl),
                tag: videoUrl,
                autoPlay: kIsWeb ? false : true,
                videoUrl: videoUrl,
                videoDetail: videoDetail!,
                loadingWidget: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    color: Colors.black,
                    child: VideoLoading(
                        coverHorizontal: videoDetail.coverHorizontal ?? ''),
                  ),
                ),
                child: (isReady) {
                  return VideoPlayerArea(
                    name: name,
                    videoUrl: videoUrl,
                    video: videoDetail,
                    tag: controllerTag,
                  );
                },
              ),
              Expanded(
                  child: Stack(
                children: [
                  CustomScrollView(
                    controller: _controller,
                    slivers: [
                      SliverToBoxAdapter(
                        child: VideoPlayerConsumer(
                          tag: videoUrl,
                          child: (videoPlayerInfo) => VideoInfo(
                            videoPlayerController: videoPlayerInfo
                                .observableVideoPlayerController
                                .videoPlayerController,
                            externalId: videoDetail.externalId ?? '',
                            title: videoDetail.title,
                            tags: videoDetail.tags ?? [],
                            timeLength: videoDetail.timeLength ?? 0,
                            viewTimes: videoDetail.videoViewTimes ?? 0,
                            actor: videoDetail.actors,
                            publisher: videoDetail.publisher,
                            videoCollectTimes:
                                videoDetail.videoCollectTimes ?? 0,
                          ),
                        ),
                      ),
                      // 演員列表
                      if (videoDetail.actors != null &&
                          videoDetail.actors!.isNotEmpty)
                        SliverToBoxAdapter(
                            child: Actors(
                          actors: videoDetail.actors!,
                        )),
                      // 輪播
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.only(top: 8, right: 8, left: 8),
                          child: VideoScreenBanner(),
                        ),
                      ),
                      // 選集
                      if (videoDetail.belongVods != null &&
                          videoDetail.belongVods!.isNotEmpty)
                        SliverToBoxAdapter(
                            child: BelongVideo(
                          key: _belongVideoKey,
                          videos: videoDetail.belongVods!,
                        )),
                      // APP 下載
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.only(top: 8, right: 8, left: 8),
                          child: AppDownloadAd(),
                        ),
                      ),
                      // 同標籤
                      SliverToBoxAdapter(
                        child: Column(
                          key: _tagVideoKey, // 使用GlobalKey
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8),
                              child: TitleHeader(text: '同標籤'),
                            ),
                            if (videoDetail.tags!.isEmpty)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Center(
                                  child: Text(
                                    '找不到相關影片，猜您也會喜歡',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF161823),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            VideoByTagConsumer(
                                excludeId: videoDetail.id.toString(),
                                tags: videoDetail.tags ?? [],
                                child: (videos) {
                                  return GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 193 / 159,
                                      crossAxisSpacing: 1,
                                      mainAxisSpacing: 1,
                                    ),
                                    itemCount: videos.length,
                                    itemBuilder: (context, index) {
                                      return VideoPreviewWidget(
                                        id: videos[index].id,
                                        title: videos[index].title,
                                        coverHorizontal:
                                            videos[index].coverHorizontal ?? '',
                                        coverVertical:
                                            videos[index].coverVertical ?? '',
                                        timeLength:
                                            videos[index].timeLength ?? 0,
                                        tags: videos[index].tags ?? [],
                                        videoViewTimes:
                                            videos[index].videoViewTimes ?? 0,
                                      );
                                    },
                                  );
                                }),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (_showButton)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (videoDetail.belongVods != null &&
                                videoDetail.belongVods!.isNotEmpty)
                              InkWell(
                                onTap: () {
                                  _scrollToPosition(_belongVideoKey);
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text('選集'),
                                ),
                              ),
                            InkWell(
                              onTap: () {
                                _scrollToPosition(_tagVideoKey);
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text('同標籤'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              )),
            ],
          ),
        );
      },
    );
  }

  void _scrollToPosition(GlobalKey key) {
    final RenderBox renderBox =
        key.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    _controller.animateTo(
      -position.dy,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOut,
    );
  }
}
