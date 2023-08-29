import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared/apis/user_api.dart';
import 'package:shared/models/vod.dart';
import 'package:shared/modules/video/video_provider.dart';
import 'package:shared/modules/video_player/video_player_consumer.dart';
import 'package:shared/modules/video_player/video_player_provider.dart';
import '../screens/video/actors.dart';
import '../screens/video/app_download_ad.dart';
import '../screens/video/banner.dart';
import '../screens/video/belong_video.dart';
import '../screens/video/video_info.dart';
import '../screens/video/video_player_area/index.dart';
import '../screens/video/video_player_area/loading.dart';
import '../widgets/title_header.dart';
import '../widgets/wave_loading.dart';

final userApi = UserApi();

class Video extends StatefulWidget {
  final Map<String, dynamic> args;

  const Video({Key? key, required this.args}) : super(key: key);

  @override
  VideoState createState() => VideoState();
}

class VideoState extends State<Video> {
  @override
  void initState() {
    super.initState();
    // setScreenRotation();
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.black));
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
    // return VideoScreen(
    //   key: ValueKey(widget.args['id']),
    //   id: int.parse(widget.args['id'].toString()),
    //   name: widget.args['name'],
    // );
    var id = int.parse(widget.args['id'].toString());
    var name = widget.args['name'];
    return VideoScreenProvider(
      id: id,
      name: name,
      child: (
          {required String? videoUrl,
          required Vod? video,
          required Vod? videoDetail}) {
        if (videoUrl == null) {
          return const WaveLoading();
        }

        // print('videoDetail.belongVods!.length: ${videoDetail!.belongVods}');

        return SafeArea(
          child: Column(
            children: [
              VideoPlayerProvider(
                tag: videoUrl,
                autoPlay: kIsWeb ? false : true,
                videoUrl: videoUrl,
                video: video!,
                videoDetail: videoDetail!,
                loadingWidget: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    color: Colors.black,
                    child: VideoLoading(
                        coverHorizontal: video.coverHorizontal ?? ''),
                  ),
                ),
                child: (isReady) {
                  return VideoPlayerArea(
                    name: name,
                    videoUrl: videoUrl,
                    video: video,
                  );
                },
              ),
              Expanded(
                child: CustomScrollView(
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
                          videoCollectTimes: videoDetail.videoCollectTimes ?? 0,
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
                    const SliverPadding(
                      padding: EdgeInsets.all(8),
                      sliver:
                          SliverToBoxAdapter(child: TitleHeader(text: '同標籤')),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
