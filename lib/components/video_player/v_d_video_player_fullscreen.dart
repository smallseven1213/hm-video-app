import 'dart:async';

import 'package:chewie/chewie.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:video_player/video_player.dart';
import 'package:wgp_video_h5app/base/index.dart';
import 'package:wgp_video_h5app/components/image/index.dart';
import 'package:wgp_video_h5app/components/index.dart';
import 'package:wgp_video_h5app/components/video_player/adaptive_controls.dart';
import 'package:wgp_video_h5app/controllers/index.dart';
import 'package:wgp_video_h5app/controllers/vod_player/chewie_vod_player.dart';
import 'package:wgp_video_h5app/helpers/index.dart';
import 'package:wgp_video_h5app/providers/index.dart';
import 'package:wgp_video_h5app/styles.dart';

class VDVideoPlayerFullScreen extends StatefulWidget {
  final String url;
  final String poster;
  final String title;
  final AsyncCallback onUpdated;
  final AsyncCallback back;
  final VDVideoPlayerFullScreenState _state = VDVideoPlayerFullScreenState();

  VDVideoPlayerFullScreen({
    Key? key,
    required this.url,
    required this.poster,
    required this.title,
    required this.onUpdated,
    required this.back,
  }) : super(key: key);

  @override
  VDVideoPlayerFullScreenState createState() => _state;
}

class VDVideoPlayerFullScreenState extends State<VDVideoPlayerFullScreen> {
  final _logger = Logger('VDVideoPlayerFullScreenState');
  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;
  VVodController? vodController = Get.find<VVodController>();
  Duration _currentPosition = Duration.zero;
  bool _isPlaying = false;
  bool showBuyConfirm = false;
  bool isTrial = false;
  bool _initialized = false;
  bool isLoading = false;

  Future<void> play() async {
    chewieController?.play();
  }

  Future<void> initializePlayer(String source, {bool force = true}) async {
    // _logger.info('get video');
    VideoPlayerController? _old;
    if (force == true) {
      _old = videoPlayerController;
    }
    videoPlayerController = VideoPlayerController.network(source);
    await videoPlayerController?.initialize();
    await videoPlayerController?.seekTo(_currentPosition);
    // _logger.info('video downloaded');
    await _createChewieController();
    if (force == true) {
      await _old?.dispose();
    }
    setState(() {
      _initialized = true;
    });
  }

  Future<void> _createChewieController() async {
    chewieController?.dispose();
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController!,
      aspectRatio: 16 / 9,
      looping: false,
      allowFullScreen: true,
      customControls: AdaptiveControls(
        title: widget.title,
        back: widget.back,
        vodController: Get.find<VVodController>(),
      ),
      errorBuilder: (_ctx, _msg) {
        return const CircularProgressIndicator();
      },
    )..addListener(_reInitListener);

    Get.find<VVodController>()
        .setChewieController(ChewieVodPlayerController(chewieController!));
    if (!kIsWeb && _isPlaying) {
      Duration buff = const Duration(milliseconds: 333);
      await Future.delayed(buff);
      setState(() {
        showBuyConfirm = false;
      });
      videoPlayerController!
          .seekTo(videoPlayerController!.value.position + buff);
      play();
    }
  }

  void _trialTrigger() {
    if (isTrial == true &&
        videoPlayerController?.value.position.inSeconds ==
            videoPlayerController?.value.duration.inSeconds) {
      if (chewieController?.isFullScreen == true) {
        chewieController?.toggleFullScreen();
      }
      setState(() {
        showBuyConfirm = true;
        isTrial = false;
      });
      videoPlayerController?.removeListener(_trialTrigger);
    }
  }

  void _reInitListener() {
    if (chewieController?.isFullScreen == false) {
      chewieController?.removeListener(_reInitListener);
      _currentPosition = videoPlayerController!.value.position;
      _isPlaying = (chewieController?.isPlaying)!;
      initializePlayer(vodController?.ready?.getVideoUrl() ?? widget.url);
    }
  }

  @override
  void initState() {
    if (!_isPlaying) {
      // if (vodController?.ready?.getVideoUrl() == null &&
      //     (vodController?.ready?.chargeType ?? 0) > 1) {
      //   setState(() {
      //     showBuyConfirm = true;
      //   });
      //   return;
      // }
      isTrial = !(vodController?.ready?.isAvailable ?? false);
      initializePlayer(vodController?.ready?.getVideoUrl() ?? widget.url)
          .then((value) {
        play();
        if (isTrial) {
          videoPlayerController?.removeListener(_trialTrigger);
          videoPlayerController?.addListener(_trialTrigger);
        }
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    if (videoPlayerController != null) {
      videoPlayerController!.dispose();
    }
    videoPlayerController?.removeListener(_trialTrigger);
    chewieController?.removeListener(_reInitListener);
    chewieController?.dispose();
    super.dispose();
  }

  Future<void> alertModal(
      {String title = '', String content = '', VoidCallback? onTap}) async {
    return showDialog(
      context: context,
      builder: (_ctx) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          titlePadding: EdgeInsets.zero,
          title: null,
          contentPadding: EdgeInsets.zero,
          content: Container(
            height: 150,
            padding:
                const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  content,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.normal),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          margin: const EdgeInsets.all(5.0),
                          padding: const EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                          ),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            color: color6,
                          ),
                          child: const Text(
                            '取消',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          if (onTap != null) {
                            onTap();
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.all(5.0),
                          padding: const EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                          ),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            color: color1,
                          ),
                          child: const Text(
                            '立刻購買',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  //   image: DecorationImage(
                  //     image: NetworkImage(widget.poster),
                  //     fit: BoxFit.cover,
                  //   ),
                ),
                child: VDImage(
                  url: widget.poster,
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.black54,
                ),
              ),
              AnimatedContainer(
                duration: const Duration(
                  milliseconds: 500,
                ),
                height: 40,
                // decoration: const BoxDecoration(color: Colors.black26),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            widget.back();
                          },
                          enableFeedback: true,
                          child: const VDIcon(VIcons.back),
                        ),
                      ),
                      Expanded(
                        flex: 10,
                        child: Text(
                          widget.title.replaceAll('', '\u2060'),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                  top: 75,
                  left: 27,
                  right: 27,
                  bottom: 40,
                ),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ],
          )
        : showBuyConfirm
            ? Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      //   image: DecorationImage(
                      //     image: NetworkImage(widget.poster),
                      //     fit: BoxFit.cover,
                      //   ),
                    ),
                    child: VDImage(url: widget.poster),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(
                      milliseconds: 500,
                    ),
                    height: 40,
                    // decoration: const BoxDecoration(color: Colors.black26),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                widget.back();
                              },
                              enableFeedback: true,
                              child: const VDIcon(VIcons.back),
                            ),
                          ),
                          Expanded(
                            flex: 10,
                            child: Text(
                              widget.title.replaceAll('', '\u2060'),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                      top: 75,
                      left: 27,
                      right: 27,
                      bottom: 40,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              (vodController?.ready?.chargeType ?? 2) > 2
                                  ? '試看結束，升級觀看完整版'
                                  : '試看結束，此視頻需付費購買',
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              '時長：${vodController?.ready?.getTimeString() ?? ''}',
                              style: const TextStyle(
                                color: color6,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              (vodController?.ready?.chargeType ?? 2) > 2
                                  ? ''
                                  : '價格：${vodController?.ready?.point} 金幣',
                              style: const TextStyle(
                                color: color6,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            (vodController?.ready?.chargeType ?? 2) > 2
                                ? const Text(
                                    '解鎖後可完整播放',
                                    style: TextStyle(
                                      color: color1,
                                    ),
                                  )
                                : Row(
                                    children: [
                                      const Text(
                                        '您的購買價格：',
                                        style: TextStyle(
                                          color: color6,
                                        ),
                                      ),
                                      Text(
                                        '${vodController?.ready?.buyPoint} 金幣',
                                        style: const TextStyle(
                                          color: color1,
                                        ),
                                      ),
                                    ],
                                  ),
                            ...((vodController?.ready?.chargeType ?? 2) > 2
                                ? []
                                : [
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        chewieController?.pause();
                                        gto('/member/wallet');
                                      },
                                      child: const Text(
                                        '金幣不足，購買金幣',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ])
                          ],
                        )),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // InkWell(
                            //   onTap: () async {
                            //     setState(() {
                            //       showBuyConfirm = false;
                            //       isTrial = true;
                            //     });
                            //     await initializePlayer(widget.url);
                            //     await Future.delayed(
                            //         const Duration(milliseconds: 168));
                            //     play();
                            //     videoPlayerController
                            //         ?.removeListener(_trialTrigger);
                            //     videoPlayerController?.addListener(_trialTrigger);
                            //   },
                            //   child: Container(
                            //     padding: const EdgeInsets.only(
                            //       top: 8,
                            //       bottom: 8,
                            //       left: 21,
                            //       right: 21,
                            //     ),
                            //     decoration: BoxDecoration(
                            //       color: color7,
                            //       borderRadius: BorderRadius.circular(4.0),
                            //     ),
                            //     child: const Text('免費試看'),
                            //   ),
                            // ),
                            InkWell(
                              onTap: () async {
                                if ((vodController?.ready?.chargeType ?? 2) >
                                    2) {
                                  gto('/member/vip');
                                } else {
                                  var code = await Get.find<VodProvider>()
                                      .purchase(vodController?.ready?.id ?? 0);
                                  if (code != '00' && code == '50508') {
                                    alertModal(
                                      title: '購買失敗',
                                      content: '金幣不足，請先充值',
                                      onTap: () {
                                        chewieController?.pause();
                                        gto('/member/wallet');
                                      },
                                    );
                                    return;
                                  }
                                  if (code != '00' && code != '50508') {
                                    Fluttertoast.showToast(
                                      msg: code == '50508'
                                          ? '購買失敗: 金幣不足'
                                          : '購買失敗: 系統異常',
                                      gravity: ToastGravity.CENTER,
                                    );
                                    return;
                                  }
                                  setState(() {
                                    showBuyConfirm = false;
                                    isLoading = true;
                                  });
                                  await Fluttertoast.showToast(
                                    msg: '購買成功',
                                    gravity: ToastGravity.CENTER,
                                  );
                                  await widget.onUpdated();
                                  await initializePlayer(
                                      vodController?.ready?.getVideoUrl() ??
                                          widget.url);
                                  setState(() {
                                    isTrial = false;
                                    isLoading = false;
                                  });
                                  play();
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.only(
                                  top: 8,
                                  bottom: 8,
                                  left: 21,
                                  right: 21,
                                ),
                                decoration: BoxDecoration(
                                  color: color1,
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Text(
                                    (vodController?.ready?.chargeType ?? 2) > 2
                                        ? '開通 VIP'
                                        : '付費購買'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : _initialized
                ? Stack(
                    children: [
                      Container(
                        decoration: const BoxDecoration(color: Colors.black),
                        padding: const EdgeInsets.only(top: 0),
                        child: GestureDetector(
                          onDoubleTap: () {},
                          onDoubleTapDown: (d) {
                            var dx = d.localPosition.dx;
                            var faster = ((dx / gs().width) * 100 > 50);
                            chewieController?.videoPlayerController.position
                                .then((value) => chewieController?.seekTo(
                                    Duration(
                                        milliseconds:
                                            (value?.inMilliseconds ?? 0) +
                                                (faster ? 10 : -10) * 1000)));
                          },
                          child: Chewie(
                            controller: chewieController!,
                          ),
                        ),
                      ),
                    ],
                  )
                : Stack(
                    children: [
                      SizedBox(
                        child: Center(
                          child: InkWell(
                            onTap: () {
                              // if (vodController?.ready?.getVideoUrl() == null &&
                              //     (vodController?.ready?.chargeType ?? 0) > 1) {
                              //   setState(() {
                              //     showBuyConfirm = true;
                              //   });
                              //   return;
                              // }
                              initializePlayer(
                                      vodController?.ready?.getVideoUrl() ??
                                          widget.url)
                                  .then((value) => play());
                            },
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              decoration: const BoxDecoration(
                                color: Colors.black,
                                //   image: DecorationImage(
                                //     image: NetworkImage(widget.poster),
                                //     fit: BoxFit.cover,
                                //   ),
                              ),
                              child: VDImage(
                                url: widget.poster,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 40,
                        // decoration: const BoxDecoration(color: Colors.black26),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: () {
                                    widget.back();
                                  },
                                  enableFeedback: true,
                                  child: const VDIcon(VIcons.back),
                                ),
                              ),
                              Expanded(
                                flex: 10,
                                child: Text(
                                  widget.title.replaceAll('', '\u2060'),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            // if (vodController?.ready?.getVideoUrl() == null &&
                            //     (vodController?.ready?.chargeType ?? 0) > 1) {
                            //   setState(() {
                            //     showBuyConfirm = true;
                            //   });
                            //   return;
                            // }
                            initializePlayer(
                                    vodController?.ready?.getVideoUrl() ??
                                        widget.url)
                                .then((value) => play());
                          },
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(60.0),
                            ),
                            child: Transform.scale(
                              scale: .4,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 8.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
  }
}
