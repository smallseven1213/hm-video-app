import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoDemoPage extends StatefulWidget {
  @override
  _VideoDemoPageState createState() => _VideoDemoPageState();
}

class _VideoDemoPageState extends State<VideoDemoPage> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        'https://cdn.ztznzz.com/a4f7a79e51614154953a6a98abb64ad6/a4f7a79e51614154953a6a98abb64ad6.m3u8')
      ..initialize().then((_) {
        _controller?.setVolume(0);
        // 确保要在初始化视频播放器后刷新组件
        setState(() {});
      });
  }

  // void _play and play() with setVolumn is 1
  void _playMe() {
    _controller?.setVolume(1);
    _controller?.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Demo'),
      ),
      body: Center(
        child: _controller!.value.isInitialized
            ? Column(
                children: [
                  AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: VideoPlayer(_controller!),
                  ),
                  // button and setState controller
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _controller!.value.isPlaying
                            ? _controller!.pause()
                            : _playMe();
                      });
                    },
                    child: Icon(
                      _controller!.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                    ),
                  ),
                ],
              )
            : CircularProgressIndicator(), // 加载中
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }
}
