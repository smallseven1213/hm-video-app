import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/bottom_navigator_controller.dart';
import 'package:shared/controllers/post_controller.dart';
import 'package:shared/controllers/system_config_controller.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/enums/charge_type.dart';
import 'package:shared/enums/purchase_type.dart';
import 'package:shared/enums/file_type.dart';
import 'package:shared/models/post.dart';
import 'package:shared/models/vod.dart';
import 'package:shared/modules/video_player/video_player_provider.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/utils/event_bus.dart';
import 'package:shared/utils/handle_url.dart';
import 'package:shared/utils/purchase.dart';
import 'package:shared/widgets/sid_image.dart';
import 'package:shared/widgets/video/index.dart';
import '../../../localization/shared_localization_delegate.dart';
import '../../widgets/video/loading.dart';

class FileListWidget extends StatelessWidget {
  final Post postDetail;
  final BuildContext context;
  final Function showConfirmDialog;
  final dynamic buttonBuilder;

  const FileListWidget({
    Key? key,
    required this.postDetail,
    required this.context,
    required this.showConfirmDialog,
    required this.buttonBuilder,
  }) : super(key: key);

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
      loadingWidget: AspectRatio(
        aspectRatio: 16 / 9,
        child: VideoLoading(coverHorizontal: file.cover),
      ),
      child: (isReady, controller) {
        return VideoPlayerWidget(
          videoUrl: videoUrl,
          video: Vod(0, ''),
          tag: 'post-$videoUrl',
          showConfirmDialog: showConfirmDialog,
          displayFullscreenIcon: false,
          displayHeader: false,
          hasPaymentProcess: false,
        );
      },
    ),);
  }

  Widget _buildUnlockButton(BuildContext context, PostController postController) {
    SharedLocalizations localizations = SharedLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: buttonBuilder(
        text: localizations.translate('view_more'),
        onPressed: () {
          if (postDetail.linkType == LinkType.video.index) {
            handlePathWithId(context, postDetail.link ?? '', removeSamePath: true);
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: buttonBuilder(
        text: postDetail.chargeType == ChargeType.vip.index
            ? localizations.translate('become_a _vip_to_unlock')
            : '${postDetail.points} ${localizations.translate('gold_coins_unlock')}',
        onPressed: () {
          if (postDetail.chargeType == ChargeType.vip.index) {
            final bottomNavigatorController =
              Get.find<BottomNavigatorController>();
          MyRouteDelegate.of(context).pushAndRemoveUntil(
            AppRoutes.home,
            args: {'defaultScreenKey': '/game'},
          );
          bottomNavigatorController.changeKey('/game');
          eventBus.fireEvent("gotoDepositAfterLogin");
          } else {
            purchase(
              context,
              type: PurchaseType.post,
              id: postDetail.id,
              onSuccess: () => postController.getPostDetail(postDetail.id),
              showConfirmDialog: showConfirmDialog,
            );
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
      final file = postDetail.files[i];
      if (file.type == FileType.image.index) {
        fileWidgets.add(_buildImageWidget(file));
      } else if (file.type == FileType.video.index) {
        fileWidgets.add(_buildVideoWidget(file));
      }
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
