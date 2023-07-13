import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:video_player/video_player.dart';

final logger = Logger();

const testUrls = [
  'https://cdn.ztznzz.com/a4f7a79e51614154953a6a98abb64ad6/a4f7a79e51614154953a6a98abb64ad6.m3u8',
  'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8'
];

class VideoDemoPage extends StatefulWidget {
  const VideoDemoPage({Key? key}) : super(key: key);
  @override
  VideoDemoPageState createState() => VideoDemoPageState();
}

class VideoDemoPageState extends State<VideoDemoPage> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();

    var random = Random();
    int index = random.nextInt(testUrls.length);
    _controller = null;
    _controller = VideoPlayerController.network(testUrls[index]);
    // _controller = VideoPlayerController.network(
    //     'https://cdn.ztznzz.com/a4f7a79e51614154953a6a98abb64ad6/a4f7a79e51614154953a6a98abb64ad6.m3u8');

    // _controller?.addListener(() {
    //   setState(() {});
    // });
    _controller?.setLooping(true);
    _controller?.initialize().then((_) {
      logger.i('TESTING LIFECYCLE -> INITIALIZE VIDEO PLAYER');
      setState(() {});
    }).catchError((onError) {
      logger.e('TESTING LIFECYCLE -> ERROR: $onError');
    });
    // _controller?.play();
    // logger.i('TESTING LIFECYCLE -> a');
    // _controller = VideoPlayerController.network(
    //   'https://cdn.ztznzz.com/a4f7a79e51614154953a6a98abb64ad6/a4f7a79e51614154953a6a98abb64ad6.m3u8',
    // )..initialize().then((_) {
    //     logger.i('TESTING LIFECYCLE -> b');
    //     _controller?.pause();
    //     _controller?.setVolume(0);
    //     // 确保要在初始化视频播放器后刷新组件
    //     setState(() {});
    //   });
  }

  // void _play and play() with setVolumn is 1
  void _playMe() {
    logger.i('TESTING LIFECYCLE -> c');
    if (!kIsWeb) {
      _controller?.setVolume(1);
    }

    _controller?.play();
  }

  // dispose
  @override
  void dispose() {
    logger.i('TESTING LIFECYCLE -> d');
    super.dispose();
    _controller?.pause();
    _controller?.dispose();
    _controller = null;
  }

  @override
  Widget build(BuildContext context) {
    logger.i('TESTING LIFECYCLE -> e');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Demo'),
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
                        logger.i('TESTING LIFECYCLE -> f');
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
            : const CircularProgressIndicator(), // 加载中
      ),
    );
  }
}
