import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/post_controller.dart';
import 'package:shared/controllers/system_config_controller.dart';
import 'package:shared/controllers/video_player_controller.dart';
import 'package:shared/enums/charge_type.dart';
import 'package:shared/enums/purchase_type.dart';
import 'package:shared/enums/file_type.dart';
import 'package:shared/localization/shared_localization_delegate.dart';
import 'package:shared/models/post.dart';
import 'package:shared/models/vod.dart';
import 'package:shared/modules/video_player/video_player_provider.dart';
import 'package:shared/utils/handle_url.dart';
import 'package:shared/utils/navigate_to_vip.dart';
import 'package:shared/utils/purchase.dart';
import 'package:shared/widgets/posts/video/index.dart';
import 'package:shared/widgets/posts/video/loading.dart';
import 'package:shared/widgets/sid_image.dart';

class FileListWidget extends StatefulWidget {
  final Post postDetail;
  final Function showConfirmDialog;
  final dynamic buttonBuilder;
  final bool? useGameDeposit;
  final Widget? loadingAnimation;

  const FileListWidget({
    Key? key,
    required this.postDetail,
    required this.showConfirmDialog,
    required this.buttonBuilder,
    this.useGameDeposit = false,
    this.loadingAnimation,
  }) : super(key: key);

  @override
  _FileListWidgetState createState() => _FileListWidgetState();
}

class _FileListWidgetState extends State<FileListWidget> {
  int currentIndex = 0;
  bool showOverlay = true;
  Map<String, ObservableVideoPlayerController> videoControllers = {};

  String? _getVideoUrl(String videoUrl) {
    final systemConfigController = Get.find<SystemConfigController>();
    if (videoUrl.isNotEmpty) {
      String uri = videoUrl.replaceAll('\\', '/').replaceAll('//', '/');
      if (uri.startsWith('http')) {
        return uri;
      }
      String id = uri.substring(uri.indexOf('/') + 1);
      return '${systemConfigController.vodHost.value}/$id/$id.m3u8';
    }
    return null;
  }

  Widget _buildImageWidget(Files file) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child:
          SidImage(sid: file.cover, width: MediaQuery.of(context).size.width),
    );
  }

  Widget _buildVideoWidget({
    required int index,
    required Files file,
    String keyName = 'post',
    VoidCallback? togglePopup,
    bool? displayFullscreenIcon = true,
    bool? autoPlay = false,
  }) {
    final videoUrl = _getVideoUrl(file.video);
    if (videoUrl == null) {
      return const SizedBox.shrink();
    }

    videoControllers['$keyName-$videoUrl'] = Get.put(
      ObservableVideoPlayerController(
        '$keyName-$videoUrl',
        videoUrl,
        autoPlay ?? false,
        false,
      ),
      tag: '$keyName-$videoUrl',
    );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: VideoPlayerProvider(
        key: Key('$keyName-$videoUrl'),
        tag: '$keyName-$videoUrl',
        autoPlay: autoPlay ?? false,
        videoUrl: videoUrl,
        videoDetail: Vod(0, ''),
        shouldMuteByDefault: false,
        child: (isReady, controller) {
          if (isReady && keyName == 'popup') {
            _syncVideoPlayer('post-$videoUrl');
          }
          return VideoPlayerWidget(
            videoUrl: videoUrl,
            video: Vod(0, ''),
            tag: '$keyName-$videoUrl',
            showConfirmDialog: widget.showConfirmDialog,
            displayHeader: false,
            togglePopup: togglePopup,
            displayFullscreenIcon: displayFullscreenIcon,
            controller: controller,
            file: file,
            loadingAnimation: widget.loadingAnimation,
          );
        },
      ),
    );
  }

  void _pauseVideo(String keyName) {
    if (videoControllers.containsKey(keyName)) {
      final controller = videoControllers[keyName]!.videoPlayerController;
      if (controller != null && controller.value.isPlaying) {
        controller.pause();
      }
    }
  }

  void _showFullScreenModal(BuildContext context, int initialIndex) async {
    int currentIndex = initialIndex;
    bool showOverlay = true;

    // pause all videos before modal open
    _pauseAllVideos();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return GestureDetector(
              onTap: () {
                setModalState(() {
                  showOverlay = !showOverlay;
                });
              },
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: [
                    CarouselSlider(
                      options: CarouselOptions(
                        height: MediaQuery.of(context).size.height,
                        viewportFraction: 1.0,
                        enlargeCenterPage: false,
                        initialPage: initialIndex,
                        scrollDirection: Axis.vertical,
                        enableInfiniteScroll:
                            widget.postDetail.files.length > 1,
                        onPageChanged: (index, reason) {
                          setModalState(() {
                            currentIndex = index;
                          });

                          // 暂停所有视频
                          _pauseAllVideos();

                          // if app 播放当前视频
                          if (kIsWeb == false) {
                            final currentFile = widget.postDetail.files[index];
                            if (currentFile.type == FileType.video.index) {
                              final videoUrl = _getVideoUrl(currentFile.video);
                              if (videoUrl != null) {
                                final controllerKey = 'popup-$videoUrl';
                                final controller =
                                    videoControllers[controllerKey];
                                if (controller != null) {
                                  // 检查视频是否已经初始化完成
                                  if (controller.videoPlayerController?.value
                                          .isInitialized ??
                                      false) {
                                    controller.videoPlayerController?.play();
                                  } else {
                                    // 如果还没有初始化完成，等待初始化后再播放
                                    controller.videoPlayerController
                                        ?.addListener(() {
                                      if (controller.videoPlayerController
                                              ?.value.isInitialized ??
                                          false) {
                                        controller.videoPlayerController
                                            ?.play();
                                      }
                                    });
                                  }
                                }
                              }
                            }
                          }
                        },
                      ),
                      items: widget.postDetail.files.map<Widget>((file) {
                        if (file.type == FileType.image.index) {
                          return SidImage(
                            sid: file.cover,
                            width: MediaQuery.of(context).size.width,
                          );
                        } else if (file.type == FileType.video.index) {
                          return _buildVideoWidget(
                            keyName: 'popup',
                            file: file,
                            index: currentIndex - 1,
                            displayFullscreenIcon: false,
                            // autoPlay: kIsWeb ? false : true,
                          );
                        }
                        return Container(); // 处理不支持的文件类型
                      }).toList(),
                    ),
                    if (showOverlay) ...[
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 80,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ),
                      Positioned(
                        top: 20,
                        left: 20,
                        child: IconButton(
                          icon: const Icon(Icons.close),
                          color: Colors.white,
                          iconSize: 16.0,
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      Positioned(
                        top: 16,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 16),
                            child: Text(
                              '${currentIndex + 1} / ${widget.postDetail.files.length}',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            );
          },
        );
      },
    );
    // Reload the video player for the current thumbnail after the modal is closed
    final currentFile = widget.postDetail.files[currentIndex];
    if (currentFile.type == FileType.video.index) {
      final videoUrl = _getVideoUrl(currentFile.video);
      if (videoUrl != null) {
        _syncVideoPlayer('popup-$videoUrl');
      }
    }
  }

  void _pauseAllVideos() {
    videoControllers.forEach((key, controller) {
      final videoPlayerController = controller.videoPlayerController;
      if (videoPlayerController != null &&
          videoPlayerController.value.isPlaying) {
        videoPlayerController.pause();
      }
    });
  }

  void _syncVideoPlayer(String sourceControllerKey) {
    String targetControllerKey;
    if (sourceControllerKey.contains('post')) {
      // Syncing from postController to popupController
      targetControllerKey = sourceControllerKey.replaceFirst('post', 'popup');
    } else if (sourceControllerKey.contains('popup')) {
      // Syncing from popupController to postController
      targetControllerKey = sourceControllerKey.replaceFirst('popup', 'post');
    } else {
      return;
    }

    if (videoControllers.containsKey(sourceControllerKey) &&
        videoControllers.containsKey(targetControllerKey)) {
      final sourceController = videoControllers[sourceControllerKey]!;
      final targetController = videoControllers[targetControllerKey]!;

      final position = sourceController.videoPlayerController?.value.position;
      if (position != null && targetController.videoPlayerController != null) {
        // Schedule the state changes after the current frame
        WidgetsBinding.instance.addPostFrameCallback((_) {
          sourceController.videoPlayerController!.pause();
          if (position.inMilliseconds != 0 &&
              targetControllerKey.contains('popup') &&
              kIsWeb == false) {
            targetController.videoPlayerController!.play();
          }
        });
      }
    }
  }

  Widget _buildThumbnail(Files file, int index) {
    return GestureDetector(
      onTap: () => _showFullScreenModal(context, index),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: file.type == FileType.image.index
            ? _buildImageWidget(file)
            : _buildVideoWidget(
                file: file,
                index: index,
                togglePopup: () {
                  _showFullScreenModal(context, index);
                },
              ),
      ),
    );
  }

  Widget _buildUnlockButton(
      BuildContext context, PostController postController) {
    SharedLocalizations localizations = SharedLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: widget.buttonBuilder(
        text: localizations.translate('view_more'),
        onPressed: () {
          if (widget.postDetail.linkType == LinkType.video.index) {
            handlePathWithId(context, widget.postDetail.link ?? '',
                removeSamePath: true);
          } else if (widget.postDetail.linkType == LinkType.link.index) {
            handleHttpUrl(widget.postDetail.link ?? '');
          }
        },
      ),
    );
  }

  Widget _buildPurchaseButton(
      BuildContext context, PostController postController) {
    SharedLocalizations localizations = SharedLocalizations.of(context)!;
    bool isButtonEnabled = true;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: widget.buttonBuilder(
        text: widget.postDetail.chargeType == ChargeType.vip.index
            ? localizations.translate('become_a_vip_to_unlock')
            : '${widget.postDetail.points} ${localizations.translate('gold_coins_unlock')}',
        onPressed: () {
          if (widget.postDetail.chargeType == ChargeType.vip.index) {
            VipNavigationHandler.navigateToPage(
              context,
              widget.useGameDeposit,
            );
          } else {
            if (!isButtonEnabled) return;
            isButtonEnabled = false;
            purchase(
              context,
              type: PurchaseType.post,
              id: widget.postDetail.id,
              onSuccess: () {
                postController.getPostDetail(widget.postDetail.id);
                isButtonEnabled = true;
              },
              showConfirmDialog: widget.showConfirmDialog,
            ).then((_) {
              isButtonEnabled = !isButtonEnabled;
            }).catchError((_) {
              isButtonEnabled = true;
            });
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> fileWidgets = [];
    final postController =
        Get.find<PostController>(tag: 'postId-${widget.postDetail.id}');

    for (int i = 0; i < widget.postDetail.files.length; i++) {
      fileWidgets.add(_buildThumbnail(widget.postDetail.files[i], i));
    }

    if (widget.postDetail.isUnlock == false) {
      fileWidgets.add(_buildPurchaseButton(context, postController));
    } else if (widget.postDetail.isUnlock &&
        widget.postDetail.link != null &&
        widget.postDetail.linkType != LinkType.none.index) {
      fileWidgets.add(_buildUnlockButton(context, postController));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: fileWidgets,
    );
  }
}
