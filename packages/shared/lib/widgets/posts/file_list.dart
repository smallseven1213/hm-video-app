import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/post_controller.dart';
import 'package:shared/controllers/system_config_controller.dart';
import 'package:shared/enums/charge_type.dart';
import 'package:shared/enums/purchase_type.dart';
import 'package:shared/enums/file_type.dart';
import 'package:shared/models/post.dart';
import 'package:shared/models/vod.dart';
import 'package:shared/modules/video_player/video_player_provider.dart';
import 'package:shared/utils/handle_url.dart';
import 'package:shared/utils/navigate_to_vip.dart';
import 'package:shared/utils/purchase.dart';
import 'package:shared/widgets/sid_image.dart';
import 'package:shared/widgets/video/index.dart';
import '../../../localization/shared_localization_delegate.dart';

class FileListWidget extends StatelessWidget {
  final Post postDetail;
  final BuildContext context;
  final Function showConfirmDialog;
  final dynamic buttonBuilder;
  final bool? useGameDeposit;

  const FileListWidget({
    Key? key,
    required this.postDetail,
    required this.context,
    required this.showConfirmDialog,
    required this.buttonBuilder,
    this.useGameDeposit = false,
  }) : super(key: key);

  Widget _buildImageWidget(Files file) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child:
          SidImage(sid: file.cover, width: MediaQuery.of(context).size.width),
    );
  }

  void _showFullScreenModal(BuildContext context, int initialIndex) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      builder: (BuildContext context) {
        return CarouselDisplay(
          postDetail: postDetail,
          initialIndex: initialIndex,
          showConfirmDialog: showConfirmDialog,
        );
      },
    );
  }

  Widget _buildThumbnail(Files file, int index) {
    return GestureDetector(
      onTap: () => _showFullScreenModal(context, index),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: file.type == FileType.image.index
            ? _buildImageWidget(file)
            : Stack(
                alignment: Alignment.center,
                children: [
                  _buildImageWidget(file),
                  Icon(Icons.play_circle_outline,
                      size: 50, color: Colors.white),
                ],
              ),
      ),
    );
  }

  Widget _buildUnlockButton(
      BuildContext context, PostController postController) {
    SharedLocalizations localizations = SharedLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: buttonBuilder(
        text: localizations.translate('view_more'),
        onPressed: () {
          if (postDetail.linkType == LinkType.video.index) {
            handlePathWithId(context, postDetail.link ?? '',
                removeSamePath: true);
          } else if (postDetail.linkType == LinkType.link.index) {
            handleHttpUrl(postDetail.link ?? '');
          } else {
            return;
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
      child: buttonBuilder(
        text: postDetail.chargeType == ChargeType.vip.index
            ? localizations.translate('become_a _vip_to_unlock')
            : '${postDetail.points} ${localizations.translate('gold_coins_unlock')}',
        onPressed: () {
          if (postDetail.chargeType == ChargeType.vip.index) {
            VipNavigationHandler.navigateToPage(
              context,
              useGameDeposit,
            );
          } else {
            if (!isButtonEnabled) return;
            isButtonEnabled = false;
            purchase(
              context,
              type: PurchaseType.post,
              id: postDetail.id,
              onSuccess: () {
                postController.getPostDetail(postDetail.id);
                isButtonEnabled = true;
              },
              showConfirmDialog: showConfirmDialog,
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
        Get.find<PostController>(tag: 'postId-${postDetail.id}');

    for (int i = 0; i < postDetail.files.length; i++) {
      fileWidgets.add(_buildThumbnail(postDetail.files[i], i));
    }

    if (postDetail.isUnlock == false) {
      fileWidgets.add(_buildPurchaseButton(context, postController));
    } else if (postDetail.isUnlock &&
        postDetail.link != null &&
        postDetail.linkType != LinkType.none.index) {
      fileWidgets.add(_buildUnlockButton(context, postController));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: fileWidgets,
    );
  }
}

class CarouselDisplay extends StatefulWidget {
  final Post postDetail;
  final int initialIndex;
  final Function showConfirmDialog;

  const CarouselDisplay({
    Key? key,
    required this.postDetail,
    required this.showConfirmDialog,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  _CarouselDisplayState createState() => _CarouselDisplayState();
}

class _CarouselDisplayState extends State<CarouselDisplay> {
  int currentIndex = 0;
  bool showOverlay = true;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  void toggleOverlay() {
    setState(() {
      showOverlay = !showOverlay;
    });
  }

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

  Widget _buildVideoWidget(Files file) {
    final videoUrl = _getVideoUrl(file.video);
    if (videoUrl == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: VideoPlayerProvider(
        key: Key('post-$videoUrl'),
        tag: 'post-$videoUrl',
        autoPlay: false,
        videoUrl: videoUrl,
        videoDetail: Vod(0, ''),
        isPost: true,
        child: (isReady, controller) {
          return VideoPlayerWidget(
            videoUrl: videoUrl,
            video: Vod(0, ''),
            tag: 'post-$videoUrl',
            showConfirmDialog: widget.showConfirmDialog,
            displayFullscreenIcon: false,
            displayHeader: false,
            hasPaymentProcess: false,
            isVerticalDragEnabled: true,
            isPost: true,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleOverlay,
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height,
                viewportFraction: 1.0,
                enlargeCenterPage: false,
                initialPage: widget.initialIndex,
                scrollDirection: Axis.vertical,
                onPageChanged: (index, reason) {
                  setState(() {
                    currentIndex = index;
                  });
                },
              ),
              items: widget.postDetail.files.map((file) {
                if (file.type == FileType.image.index) {
                  return SidImage(
                    sid: file.cover,
                    width: MediaQuery.of(context).size.width,
                  );
                } else if (file.type == FileType.video.index) {
                  return _buildVideoWidget(file);
                }
                return Container(); // 不支持的文件类型的占位符
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
                  color: Colors.white, // 圖標顏色設定為黑色
                  iconSize: 16.0, // 圖標大小
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
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
