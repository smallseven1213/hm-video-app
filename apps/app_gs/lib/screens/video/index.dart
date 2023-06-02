// VideoScreen stateless
import 'dart:async';

import 'package:app_gs/screens/video/video_player_area/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/play_record_controller.dart';
import 'package:shared/controllers/video_detail_controller.dart';
import 'package:shared/models/vod.dart';

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
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late StreamSubscription<bool> videoUrlSubscription;
  VideoDetailController? videoDetailController;

  @override
  void initState() {
    super.initState();
    videoDetailController =
        Get.put(VideoDetailController(widget.id), tag: widget.id.toString());
    videoUrlSubscription = videoDetailController!.isLoading.listen((isLoading) {
      if (isLoading == false) {
        _putController();
      }
    });
  }

  void _putController() async {
    var video = videoDetailController!.video.value;
    var videoDetail = videoDetailController!.videoDetail.value;

    var playRecord = Vod(
      video!.id,
      video.title,
      coverHorizontal: video!.coverHorizontal!,
      coverVertical: video.coverVertical!,
      timeLength: video.timeLength!,
      tags: videoDetail!.tags!,
      videoViewTimes: videoDetail.videoViewTimes!,
      // detail: detail!,
    );
    Get.find<PlayRecordController>(tag: 'vod').addPlayRecord(playRecord);
    setState(() {});
  }

  @override
  void dispose() {
    videoUrlSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Obx(() {
          var video = videoDetailController!.video.value;
          var videoDetail = videoDetailController!.videoDetail.value;

          return Column(
            children: [
              video != null
                  ? VideoPlayerArea(
                      name: widget.name,
                      videoUrl: videoDetailController!.videoUrl.value,
                      video: video,
                    )
                  : AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(
                        color: Colors.black,
                        child: CustomAppBar(
                          title: widget.name ?? '',
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                    ),
              Expanded(
                child: video != null && videoDetail != null
                    ? NestedTabBarView(
                        videoBase: video,
                        videoDetail: videoDetail,
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      ),
              )
            ],
          );
        }),
      ),
    );
  }
}
