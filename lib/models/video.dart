import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:video_player/video_player.dart';

import '../controllers/app_controller.dart';
import '../providers/vod_provider.dart';

class Video {
  int id;
  String title;
  int? film;
  int? chargeType; // 付費類型：1 免費, 2 金幣, 3 VIP
  String? points;
  String? coverVertical;
  String? coverHorizontal;
  String? videoUrl;
  bool? isPreview;
  bool? isCollected;
  String? externalId;
  String? buyPoints = "0";
  bool isPlay = false;
  bool started = false;

  VideoPlayerController? controller;

  String? getVideoUrl() {
    if (videoUrl != null && videoUrl!.isNotEmpty) {
      // print(videoUrlUd);
      String uri = videoUrl!.replaceAll('\\', '/').replaceAll('//', '/');
      // print(uri);
      if (uri.startsWith('http')) {
        return uri;
      }
      String id = uri.substring(uri.indexOf('/') + 1);
      return '${AppController.cc.endpoint.getVideoPrefix()}/$id/$id.m3u8';
    }
    return null;
  }

  Video(
      {
        required this.id,
        required this.title,
        this.film,
        this.chargeType,
        this.points,
        this.buyPoints,
        this.isCollected,
        this.externalId,
        this.videoUrl,
        this.isPreview,
        this.coverHorizontal,
        this.coverVertical
      });

  Video.fromJson(Map<dynamic, dynamic> json)
      : id = json['id'],
        title = json['title'],
        film = json['film'],
        chargeType = json['chargeType'],
        points = json['points'],
        buyPoints = json['buyPoints'],
        isCollected = json['isCollected'],
        externalId = json['externalId'],
        videoUrl = json['videoUrl'],
        isPreview = json['isPreview'],
        coverHorizontal = json['coverHorizontal'],
        coverVertical = json['coverVertical'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id']= this.id;
    data['title']= this.title;
    data['film']= this.film;
    data['chargeType']= this.chargeType;
    data['points']= this.points;
    data['buyPoints']= this.buyPoints;
    data['isCollected']= this.isCollected;
    data['externalId']= this.externalId;
    data['videoUrl']= this.videoUrl;
    data['isPreview']= this.isPreview;
    data['coverHorizontal']= this.coverHorizontal;
    data['coverVertical']= this.coverVertical;
    return data;
  }

  Future<VideoPlayerController?> loadController() async {
    if (getVideoUrl() == null) {
      Video video = await Get.find<VodProvider>().getById(id);
      film = video.film;
      chargeType = video.chargeType;
      points = video.points;
      buyPoints = video.buyPoints;
      isCollected = video.isCollected;
      externalId = video.externalId;
      videoUrl = video.videoUrl;
      isPreview = video.isPreview;
      coverHorizontal = video.coverHorizontal;
      coverVertical = video.coverVertical;
    }

    controller ??= VideoPlayerController.network(getVideoUrl()!)..initialize().then((value) => {
        controller?.setLooping(true),
      });
    return controller;
  }

  Future<bool> trigger () async {
    if (isPlay) {
      pause();
    } else {
      play();
    }
    return !isPlay;
  }

  pause() {
    if (!canPlay()) {
      return;
    }
    print("$id pause");
    if (controller == null) {
      loadController().whenComplete(() => {
        isPlay = false,
        controller!.pause()
      });
    } else {
      isPlay = false;
      controller!.removeListener(() {});
      controller!.pause();
      // controller!.seekTo(Duration(milliseconds: 0));
    }
  }

  Future<bool> play () async {
    if (!canPlay()) {
      return false;
    }
    print("$id play");
    if (controller == null) {
      loadController().whenComplete(() {
        isPlay = true;
        controller!.play();
      });
    } else {
      await Future.delayed(const Duration(milliseconds: 500));
      isPlay = true;
      controller!.play();
    }
    return false;
  }

  bool canPlay() {
    return isPreview ?? false || chargeType == 1;
  }
}
