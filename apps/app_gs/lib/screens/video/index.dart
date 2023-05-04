// VideoScreen stateless
import 'package:app_gs/screens/video/video_player_area/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/video_detail_controller.dart';

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
          () => videoDetailController.video.value.id != 0
              ? Column(
                  children: [
                    VideoPlayerArea(
                      id: widget.id,
                      name: widget.name,
                      videoUrl: videoDetailController.videoUrl.value,
                      video: videoDetailController.video.value,
                    ),
                    videoDetailController.videoDetail.value.id != 0
                        ? Expanded(
                            child: NestedTabBarView(
                              videoBase: videoDetailController.video.value,
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
