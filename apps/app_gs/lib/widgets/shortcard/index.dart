import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/short_video_detail_controller.dart';
import 'package:shared/controllers/video_detail_controller.dart';
import 'package:shared/controllers/video_player_controller.dart';
import 'package:shared/widgets/video_player/player.dart';

import '../../pages/video.dart';
import '../../screens/video/video_player_area/index.dart';
import 'short_card_info.dart';

final logger = Logger();

class ShortCard extends StatefulWidget {
  final int index;
  final int id;
  final String title;

  const ShortCard({
    Key? key,
    required this.index,
    required this.id,
    required this.title,
  }) : super(key: key);

  @override
  _ShortCardState createState() => _ShortCardState();
}

class _ShortCardState extends State<ShortCard> {
  ShortVideoDetailController? videoDetailController;
  ObservableVideoPlayerController? videoPlayerController;

  @override
  void initState() {
    logger.i('RENDER OBX: ShortCard initState');
    super.initState();
    videoDetailController = Get.put(ShortVideoDetailController(widget.id),
        tag: widget.id.toString());
  }

  @override
  void didChangeDependencies() async {
    logger.i('RENDER OBX: ShortCard didChangeDependencies');
    super.didChangeDependencies();
    videoDetailController!.videoUrl.listen((videoUrl) {
      if (videoUrl.isNotEmpty) {
        videoPlayerController?.dispose();
        Get.putAsync<ObservableVideoPlayerController>(() async {
          videoPlayerController = ObservableVideoPlayerController(videoUrl);
          setState(() {});
          return videoPlayerController!;
        }, tag: videoUrl);
      }
    });
  }

  @override
  void dispose() {
    videoDetailController?.dispose();
    videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var video = videoDetailController!.video.value;
      var videoDetail = videoDetailController!.videoDetail.value;

      if (video != null && videoDetailController!.videoUrl.value.isNotEmpty) {
        logger.i('RENDER OBX: ShortCard');
        return Stack(
          children: [
            SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: VideoPlayerWidget(
                video: video,
                videoUrl: videoDetailController!.videoUrl.value,
              ),
            ),
            if (videoDetail != null)
              ShortCardInfo(
                  index: widget.index,
                  data: videoDetail,
                  title: widget.title,
                  videoUrl: videoDetailController!.videoUrl.value)
          ],
        );
      } else {
        return const Expanded(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
    });
  }
}
