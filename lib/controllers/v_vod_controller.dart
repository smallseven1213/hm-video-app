import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wgp_video_h5app/controllers/vod_player/abstract_vod_player.dart';
import 'package:wgp_video_h5app/models/index.dart';
import 'package:wgp_video_h5app/providers/index.dart';

class VVodController extends GetxController {
  Vod? ready;
  AbstractVodPlayerController? vodPlayerController;
  bool isFullscreen = false;
  CancelableOperation? orientationRelease;

  setChewieController(AbstractVodPlayerController _controller) {
    vodPlayerController = _controller;
    update();
  }

  Future<Vod?> readyPlay(int vodId) async {
    if (!kIsWeb) {
      SystemChrome.setPreferredOrientations([
        //你要的方向
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]);
    }

    var _provider = Get.find<VodProvider>();
    var vod = await _provider.getVodUrl(vodId);
    // _provider.getVodDetail(vod);
    // print(vod);
    ready = vod;
    update();
    return vod;
  }

  Future<Vod> updateReadyPlay(Vod vod) async {
    var _provider = Get.find<VodProvider>();
    vod = await _provider.refreshVodUrl(vod);
    ready = vod;
    update();
    return vod;
  }

  void setFullscreen(bool val) {
    isFullscreen = val;
    update();
  }

  Future<void> toggleFullscreen({
    bool? force,
  }) async {
    isFullscreen = force ?? !isFullscreen;
    if (isFullscreen) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
    update();

    await orientationRelease?.cancel();
    orientationRelease = CancelableOperation.fromFuture(
            Future.delayed(const Duration(seconds: 10)))
        .then((p0) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]);
    });
    update();
  }

  Future<void> disposeVod() async {
    await orientationRelease?.cancel();

    if (!kIsWeb) {
      SystemChrome.setPreferredOrientations([
        //你要的方向
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }

    ready = null;
    update();
  }
}
