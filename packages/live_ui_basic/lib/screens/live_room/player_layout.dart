import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:live_core/models/chat_message.dart';
import 'package:live_core/socket/live_web_socket_manager.dart';
import 'package:live_core/widgets/room_payment_check.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

class PlayerLayout extends StatefulWidget {
  final Uri uri;
  final int pid;

  const PlayerLayout({Key? key, required this.uri, required this.pid})
      : super(key: key);

  @override
  PlayerLayoutState createState() => PlayerLayoutState();
}

class PlayerLayoutState extends State<PlayerLayout>
    with WidgetsBindingObserver {
  final LiveSocketIOManager socketManager = LiveSocketIOManager();
  late VideoPlayerController videoController;
  late final Connectivity _connectivity;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _connectivity = Connectivity();
    _initializeConnectivityListener();
    initializeVideoPlayer();
    socketManager.socket!.on('chatresult', (data) => handleChatResult(data));
    Wakelock.enable(); // Prevent the device from sleeping
  }

  void handleChatResult(dynamic data) {
    var decodedData = jsonDecode(data);
    for (var item in decodedData) {
      if (item['objChat']['ntype'] == 0) {
        if (item['objChat']['data'] == 'hostconnect' && hasError == true) {
          setState(() {
            hasError = false;
          });
          initializeVideoPlayer();
        }
      }
    }
  }

  void _initializeConnectivityListener() async {
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      // 检查网络是否断开
      if (result == ConnectivityResult.none) {
        // 网络断开时的逻辑
        if (!hasError) {
          setState(() {
            hasError = true;
          });
        }
      } else {
        // 网络连接时的逻辑
        if (hasError) {
          setState(() {
            hasError = false;
          });
          initializeVideoPlayer();
        }
      }
    });
  }

  void initializeVideoPlayer() {
    try {
      videoController =
          VideoPlayerController.networkUrl(Uri.parse(widget.uri.toString()))
            ..initialize().then((_) {
              if (mounted) {
                setState(() {
                  hasError = false;
                });
                videoController.play();
              }
            });
      // }).catchError((error) {
      //   print('[V]video catch error: $error');
      //   if (mounted) {
      // setState(() {
      //   hasError = true;
      // });
      // handleVideoError();
      //   }
      // });

      // videoController.addListener(() {
      //   print('[V]video display listener, hasError: ${videoController.value}');
      //   if (videoController.value.hasError) {
      //     print('[V]video display error');
      //     setState(() {
      //       hasError = true;
      //     });
      //     handleVideoError();
      //   }
      // });
    } catch (e) {
      // setState(() {
      //   hasError = true;
      // });
      // handleVideoError();
    }
  }

  @override
  void dispose() {
    videoController.dispose();
    _connectivitySubscription.cancel();
    Wakelock.disable(); // Allow the device to sleep again
    socketManager.socket!.off('chatresult');
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      // 應用進入背景，暫停視頻
      videoController.pause();
    } else if (state == AppLifecycleState.resumed) {
      // 應用返回前台，重新初始化視頻播放器
      initializeVideoPlayer();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (hasError) {
      return Container(
        color: Colors.black,
        alignment: Alignment.center,
        child: const Text(
          'Error loading video. Attempting to reconnect...',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return Stack(
      children: [
        Container(
          color: Colors.black,
          alignment: Alignment.center,
          child: videoController.value.isInitialized
              ? VideoPlayer(videoController)
              : const CircularProgressIndicator(),
        ),
        RoomPaymentCheck(
            pid: widget.pid,
            child: (bool hasPermission) {
              return hasPermission
                  ? const SizedBox()
                  : Positioned.fill(
                      child: Center(
                      child: ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200.withOpacity(0.5)),
                          ),
                        ),
                      ),
                    ));
            }),
      ],
    );
  }
}
