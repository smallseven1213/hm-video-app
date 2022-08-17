import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:universal_html/js.dart' as js;
import 'package:video_js/video_js.dart';
import 'package:wgp_video_h5app/base/index.dart';
import 'package:wgp_video_h5app/components/image/index.dart';
import 'package:wgp_video_h5app/components/index.dart';
import 'package:wgp_video_h5app/components/video_player/v_d_video_js_widget.dart';
import 'package:wgp_video_h5app/controllers/index.dart';
import 'package:wgp_video_h5app/controllers/vod_player/videoJs_vod_player.dart';
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

class VDVideoPlayerFullScreenState extends State<VDVideoPlayerFullScreen>
    with RouteAware {
  final _logger = Logger('VDVideoPlayerFullScreenState');
  VideoJsController? videoPlayerController;
  VideoJsController? chewieController;
  VVodController? vodController = Get.find<VVodController>();
  bool showBuyConfirm = false;
  bool _initialized = false;
  bool isTrial = false;
  bool isLoading = false;
  double forwardOpacity = 0;
  bool forwardRewind = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    AppController.cc.routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    js.context['endOfTrial'] = () {
      if (isTrial) {
        setState(() {
          isTrial = false;
          showBuyConfirm = true;
        });
      }
    };
    Get.find<VVodController>()
        .setChewieController(VideoJsVodPlayerController(chewieController!));
  }

  Future<void> play() async {
    chewieController?.play();
  }

  Future<void> initializePlayer(String source, {bool force = true}) async {
    chewieController = VideoJsController(
      "vod-${vodController?.ready?.id}",
      videoJsOptions: VideoJsOptions(
        controls: true,
        loop: false,
        muted: false,
        poster: widget.poster,
        aspectRatio: '16:9',
        fluid: false,
        language: 'zh',
        liveui: false,
        notSupportedMessage: '',
        playbackRates: [1, 2, 3],
        preferFullWindow: false,
        responsive: false,
        sources: [
          Source(source, 'application/x-mpegURL'),
        ],
        suppressNotSupportedError: false,
      ),
    );
    Get.find<VVodController>()
        .setChewieController(VideoJsVodPlayerController(chewieController!));
    await Future.delayed(const Duration(milliseconds: 666));
    setState(() {
      _initialized = true;
    });
    await Future.delayed(const Duration(milliseconds: 66));
    play();
  }

  @override
  void initState() {
    VideoJsResults().init();
    js.context['endOfTrial'] = () {
      if (isTrial) {
        setState(() {
          isTrial = false;
          showBuyConfirm = true;
        });
      }
    };
    initializePlayer(vodController?.ready?.getVideoUrl() ?? widget.url);
    super.initState();
    // if (vodController?.ready?.getVideoUrl() == null &&
    //     (vodController?.ready?.chargeType ?? 0) > 1) {
    //   setState(() {
    //     showBuyConfirm = true;
    //   });
    //   return;
    // }
    isTrial = !(vodController?.ready?.isAvailable ?? false);
    Future.delayed(const Duration(milliseconds: 33)).then((value) {
      play();
    });
  }

  @override
  void dispose() {
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
                // decoration: BoxDecoration(
                //   image: DecorationImage(
                //     image: NetworkImage(widget.poster),
                //     fit: BoxFit.cover,
                //   ),
                // ),
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
                decoration: const BoxDecoration(color: Colors.black26),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            back();
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
                    // decoration: BoxDecoration(
                    //   image: DecorationImage(
                    //     image: NetworkImage(widget.poster),
                    //     fit: BoxFit.cover,
                    //   ),
                    // ),
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
                    decoration: const BoxDecoration(color: Colors.black26),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                back();
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
                      top: 80,
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
                                        '${vodController?.ready?.point} 金幣',
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
                            //   onTap: () {
                            //     setState(() {
                            //       showBuyConfirm = false;
                            //       isTrial = true;
                            //     });
                            //     Future.delayed(const Duration(milliseconds: 33))
                            //         .then((value) {
                            //       play();
                            //     });
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
                                        vodController?.vodPlayerController
                                            ?.pause();
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
                            setState(() {
                              forwardRewind = faster; // true: forward
                              forwardOpacity = .8;
                            });
                            chewieController?.currentTime((p0) {
                              chewieController?.setCurrentTime(
                                  (double.parse(p0) + (faster ? 10 : -10))
                                      .toString());
                            });
                            Future.delayed(const Duration(milliseconds: 333))
                                .then((value) {
                              setState(() {
                                forwardOpacity = 0;
                              });
                            });
                          },
                          child: Stack(
                            children: [
                              VDVideoJsWidget(
                                videoJsController: chewieController!,
                                height: gs().height / 1.5,
                                width: gs().width,
                                title: widget.title,
                              ),
                              Container(
                                width: gs().width,
                                alignment: forwardRewind
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: AnimatedOpacity(
                                  duration: const Duration(milliseconds: 666),
                                  opacity: forwardOpacity,
                                  child: Container(
                                    width: gs().width * .4,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 50.0),
                                    decoration: BoxDecoration(
                                      color: Colors.black45,
                                      borderRadius: forwardRewind
                                          ? const BorderRadius.only(
                                              topLeft: Radius.circular(235),
                                              bottomLeft: Radius.circular(235),
                                            )
                                          : const BorderRadius.only(
                                              topRight: Radius.circular(235),
                                              bottomRight: Radius.circular(235),
                                            ),
                                    ),
                                    alignment: forwardRewind
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          forwardRewind
                                              ? Icons.fast_forward_rounded
                                              : Icons.fast_rewind_rounded,
                                          color: Colors.white70,
                                        ),
                                        const Text(
                                          '10 秒',
                                          style: TextStyle(
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
                              if (vodController?.ready?.getVideoUrl() == null &&
                                  (vodController?.ready?.chargeType ?? 0) > 1) {
                                setState(() {
                                  showBuyConfirm = true;
                                });
                                return;
                              }
                              initializePlayer(
                                      vodController?.ready?.getVideoUrl() ?? '')
                                  .then((value) => play());
                            },
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              // decoration: BoxDecoration(
                              //   image: DecorationImage(
                              //     image: NetworkImage(widget.poster),
                              //     fit: BoxFit.cover,
                              //   ),
                              // ),
                              child: VDImage(
                                url: widget.poster,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 40,
                        decoration: const BoxDecoration(color: Colors.black26),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: () {
                                    back();
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
                            if (vodController?.ready?.getVideoUrl() == null &&
                                (vodController?.ready?.chargeType ?? 0) > 1) {
                              setState(() {
                                showBuyConfirm = true;
                              });
                              return;
                            }
                            initializePlayer(
                                    vodController?.ready?.getVideoUrl() ?? '')
                                .then((value) => play());
                          },
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: color1_03,
                              borderRadius: BorderRadius.circular(60.0),
                            ),
                            child: Transform.scale(
                              scale: .4,
                              child: const VDIcon(
                                VIcons.play,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
  }
}
