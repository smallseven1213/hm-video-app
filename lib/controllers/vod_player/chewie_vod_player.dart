import 'package:chewie/chewie.dart';
import 'package:wgp_video_h5app/controllers/vod_player/abstract_vod_player.dart';

class ChewieVodPlayerController implements AbstractVodPlayerController {
  final ChewieController _controller;
  ChewieVodPlayerController(this._controller);

  @override
  void pause() {
    _controller.pause();
  }

  @override
  void play() {
    _controller.play();
  }
}
