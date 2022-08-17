import 'package:video_js/video_js.dart';
import 'package:wgp_video_h5app/controllers/vod_player/abstract_vod_player.dart';

class VideoJsVodPlayerController implements AbstractVodPlayerController {
  final VideoJsController _controller;
  VideoJsVodPlayerController(this._controller);
  @override
  void pause() {
    _controller.pause();
  }

  @override
  void play() {
    _controller.play();
  }
}
