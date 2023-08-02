import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart' as rx;
import 'package:uuid/uuid.dart' as uuid;
import '../../controllers/play_record_controller.dart';
import '../../controllers/video_detail_controller.dart';
import '../../controllers/video_player_controller.dart';
import '../../models/vod.dart';
import '../../utils/controller_tag_genarator.dart';

class VideoScreenBuilder extends StatefulWidget {
  final int id;
  final String? name;
  final Widget Function({
    required String? videoUrl,
    required Vod? video,
    required Vod? videoDetail,
  }) child;

  const VideoScreenBuilder({
    Key? key,
    required this.id,
    required this.child,
    this.name,
  }) : super(key: key);

  @override
  VideoScreenBuilderState createState() => VideoScreenBuilderState();
}

class VideoScreenBuilderState extends State<VideoScreenBuilder> {
  late final String controllerTag;
  late final VideoDetailController controller;
  late final ObservableVideoPlayerController observableVideoPlayerController;
  late rx.BehaviorSubject<bool> isReadySubject;

  // state
  String? stateVideoUrl;
  Vod? stateVideo;
  Vod? stateVideoDetail;

  @override
  void initState() {
    super.initState();

    controllerTag = genaratorLongVideoDetailTag(widget.id.toString());

    if (!Get.isRegistered<VideoDetailController>(tag: controllerTag)) {
      controller = Get.put<VideoDetailController>(
          VideoDetailController(widget.id),
          tag: controllerTag);
    } else {
      controller = Get.find<VideoDetailController>(tag: controllerTag);
    }

    // 創建一個subject來監聽三個值的變化
    isReadySubject = rx.BehaviorSubject<bool>.seeded(false);

    // 監聽三個值的變化
    rx.Rx.combineLatest3<String, Vod?, Vod?, bool>(
      controller.videoUrl.stream,
      controller.video.stream,
      controller.videoDetail.stream,
      (videoUrl, video, videoDetail) =>
          videoUrl.isNotEmpty && video != null && videoDetail != null,
    ).listen((isReady) {
      // 一旦三個值都有值，則執行相應的操作
      if (isReady) {
        isReadySubject.add(isReady);
        var videoUrl = controller.videoUrl.value;
        var video = controller.video.value;
        var videoDetail = controller.videoDetail.value;

        setState(() {
          stateVideoUrl = controller.videoUrl.value;
          stateVideo = controller.video.value;
          stateVideoDetail = controller.videoDetail.value;
        });
        // 下一步Get訂閱和操作
        if (!Get.isRegistered<ObservableVideoPlayerController>(
          tag: videoUrl,
        )) {
          Get.lazyPut<ObservableVideoPlayerController>(
            () => ObservableVideoPlayerController(
              const uuid.Uuid().v4(),
              videoUrl,
            ),
            tag: videoUrl,
          );
        }

        observableVideoPlayerController =
            Get.find<ObservableVideoPlayerController>(tag: videoUrl);

        if (videoDetail != null && video != null) {
          var playRecord = Vod(
            video.id,
            video.title,
            coverHorizontal: video.coverHorizontal!,
            coverVertical: video.coverVertical!,
            timeLength: video.timeLength!,
            tags: video.tags!,
            videoViewTimes: videoDetail.videoViewTimes!,
          );
          Get.find<PlayRecordController>(tag: 'vod').addPlayRecord(playRecord);
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    Get.delete<VideoDetailController>(tag: controllerTag);
    observableVideoPlayerController.dispose();
    Get.delete<ObservableVideoPlayerController>(tag: stateVideoUrl);
    isReadySubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child(
      videoUrl: stateVideoUrl,
      video: stateVideo,
      videoDetail: stateVideoDetail,
    );
  }
}
