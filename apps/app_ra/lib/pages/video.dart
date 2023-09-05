import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared/apis/user_api.dart';
import 'package:shared/models/vod.dart';
import 'package:shared/modules/video/video_provider.dart';
import 'package:shared/modules/video_player/video_player_consumer.dart';
import 'package:shared/modules/video_player/video_player_provider.dart';
import 'package:shared/modules/videos/video_by_tag_consumer.dart';
import '../screens/video/actors.dart';
import '../screens/video/app_download_ad.dart';
import '../screens/video/banner.dart';
import '../screens/video/belong_video.dart';
import '../screens/video/nested_tab_bar_view/index.dart';
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

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.black));
  }

  @override
  void dispose() {
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
                child: NestedTabBarView(
                  videoUrl: videoUrl,
                  videoBase: video,
                  videoDetail: videoDetail,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
