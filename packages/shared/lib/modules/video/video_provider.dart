/// 影片資料的Provider, 必須在影片最上面
/// 可以提供videoUrl, video, videoDetail三個值
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart' as rx;
import '../../controllers/play_record_controller.dart';
import '../../controllers/video_detail_controller.dart';
import '../../enums/play_record_type.dart';
import '../../models/vod.dart';
import '../../utils/controller_tag_genarator.dart';
import '../../apis/user_api.dart';

final userApi = UserApi();

class VideoScreenProvider extends StatefulWidget {
  final int id;
  final String? name;
  final Widget Function({
    required String? videoUrl,
    required Vod? videoDetail,
  }) child;

  const VideoScreenProvider({
    Key? key,
    required this.id,
    required this.child,
    this.name,
  }) : super(key: key);

  @override
  VideoScreenProviderState createState() => VideoScreenProviderState();
}

class VideoScreenProviderState extends State<VideoScreenProvider> {
  late final String controllerTag;
  late final VideoDetailController controller;
  late rx.BehaviorSubject<bool> isReadySubject;

  // state
  String? stateVideoUrl;
  Vod? stateVideo;
  Vod? stateVideoDetail;

  @override
  void initState() {
    super.initState();

    // record user play recrod
    // userApi.addPlayHistory(widget.id);

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
    rx.Rx.combineLatest2<String, Vod?, bool>(
      controller.videoUrl.stream,
      controller.videoDetail.stream,
      (videoUrl, videoDetail) => videoUrl.isNotEmpty && videoDetail != null,
    ).listen((isReady) {
      // 一旦三個值都有值，則執行相應的操作
      if (isReady) {
        isReadySubject.add(isReady);
        var videoDetail = controller.videoDetail.value;

        if (mounted) {
          setState(() {
            stateVideoUrl = controller.videoUrl.value;
            stateVideo = controller.videoDetail.value;
            stateVideoDetail = controller.videoDetail.value;
          });
        }

        if (videoDetail != null) {
          var playRecord = Vod(
            videoDetail.id,
            videoDetail.title,
            coverHorizontal: videoDetail.coverHorizontal!,
            coverVertical: videoDetail.coverVertical!,
            timeLength: videoDetail.timeLength!,
            tags: videoDetail.tags!,
            videoViewTimes: videoDetail.videoViewTimes!,
          );
          Get.find<PlayRecordController>(tag: PlayRecordType.video.toString())
              .addPlayRecord(playRecord);
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    Get.delete<VideoDetailController>(tag: controllerTag);
    isReadySubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child(
      videoUrl: stateVideoUrl,
      videoDetail: stateVideoDetail,
    );
  }
}
