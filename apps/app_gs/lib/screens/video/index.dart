import 'package:app_gs/screens/video/video_player_area/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared/widgets/video_screen_builder/video_screen_builder.dart';
import 'package:logger/logger.dart';
import 'package:shared/models/vod.dart';

import '../../widgets/wave_loading.dart';
import 'nested_tab_bar_view/index.dart';
import '../../widgets/custom_app_bar.dart';

final logger = Logger();

class VideoScreen extends StatefulWidget {
  final int id;
  final String? name;

  const VideoScreen({
    Key? key,
    required this.id,
    this.name,
  }) : super(key: key);

  @override
  VideoScreenState createState() => VideoScreenState();
}

class VideoScreenState extends State<VideoScreen> {
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
    return VideoScreenBuilder(
      id: widget.id,
      name: widget.name,
      child: (
          {required String? videoUrl,
          required Vod? video,
          required Vod? videoDetail}) {
        if (videoUrl == null) {
          return const WaveLoading(
            color: Color.fromRGBO(255, 255, 255, 0.3),
            duration: Duration(milliseconds: 1000),
            size: 17,
            itemCount: 3,
          );
        }
        return SafeArea(
          child: Column(
            children: [
              video != null
                  ? VideoPlayerArea(
                      name: widget.name,
                      videoUrl: videoUrl,
                      video: video,
                    )
                  : AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(
                        color: Colors.black,
                        child: CustomAppBar(
                          title: widget.name,
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                    ),
              Expanded(
                child: video != null && videoDetail != null
                    ? NestedTabBarView(
                        videoUrl: videoUrl,
                        videoBase: video,
                        videoDetail: videoDetail,
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      ),
              )
            ],
          ),
        );
      },
    );
  }
}
