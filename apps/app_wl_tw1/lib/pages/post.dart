import 'package:app_wl_tw1/utils/purchase.dart';
import 'package:app_wl_tw1/widgets/button.dart';
import 'package:app_wl_tw1/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/post_controller.dart';
import 'package:shared/controllers/system_config_controller.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/enums/charge_type.dart';
import 'package:shared/enums/purchase_type.dart';
import 'package:shared/enums/file_type.dart';
import 'package:shared/models/post.dart';
import 'package:shared/models/post_detail.dart';
import 'package:shared/models/vod.dart';
import 'package:shared/modules/post/post_consumer.dart';
import 'package:shared/modules/video_player/video_player_provider.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/widgets/avatar.dart';
import 'package:shared/widgets/posts/follow_button.dart';
import 'package:shared/widgets/posts/post_stats.dart';
import 'package:shared/widgets/posts/tags.dart';
import 'package:shared/widgets/posts/serial_list.dart';
import 'package:shared/widgets/posts/recommend_list.dart';

import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:shared/widgets/sid_image.dart';

import '../screens/nodata/index.dart';
import '../screens/video/video_player_area/index.dart';
import '../screens/video/video_player_area/loading.dart';

// 定義顏色配置
class AppColors {
  static const contentText = Colors.white;
  static const darkText = Color(0xff919bb3);
}

class PostPage extends StatelessWidget {
  final int id;
  final bool? isDarkMode;

  const PostPage({
    Key? key,
    required this.id,
    this.isDarkMode = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PostConsumer(
      id: id,
      child: (PostDetail? postDetail) {
        if (postDetail == null) {
          return const NoDataScreen();
        }
        return Scaffold(
          key: Key(
              'postDetail-${postDetail.post.id}-${postDetail.post.isUnlock}'),
          appBar: CustomAppBar(
            titleWidget: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (postDetail.post.supplier != null)
                  AvatarWidget(
                    height: 30,
                    width: 30,
                    photoSid: postDetail!.post.supplier!.photoSid,
                    backgroundColor: Color(0xFFFFFFFF),
                  ),
                const SizedBox(width: 8),
                if (postDetail.post.supplier != null)
                  Text(
                    postDetail.post.supplier!.aliasName ?? '',
                    style: const TextStyle(fontSize: 15),
                  ),
              ],
            ),
            actions: [
              if (postDetail.post.supplier != null)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 17),
                  child: FollowButton(supplier: postDetail.post.supplier!),
                ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    postDetail.post.title,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.contentText,
                    ),
                  ),
                  PostStatsWidget(
                    viewCount: postDetail.post.viewCount ?? 0,
                    likeCount: postDetail.post.likeCount ?? 0,
                    postId: postDetail.post.id,
                    isLiked: postDetail.post.isLike,
                  ),
                  HtmlWidget(
                    postDetail.post.content ?? '',
                    textStyle: const TextStyle(
                      fontSize: 13,
                      color: AppColors.contentText,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  TagsWidget(
                    tags: postDetail.post.tags,
                  ),
                  const SizedBox(height: 8),
                  // 照片 or 影片
                  FileListWidget(postDetail: postDetail.post),
                  // 做一個連載的組件，向右滑動可以看到 postDetail.serials 的內容
                  SerialListWidget(
                    series: postDetail.series,
                    totalChapter: postDetail.post.totalChapter ?? 0,
                  ),
                  RecommendWidget(recommendations: postDetail.recommend)
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class FileListWidget extends StatelessWidget {
  final Post postDetail;

  const FileListWidget({Key? key, required this.postDetail}) : super(key: key);

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
      child: SidImage(
        sid: file.cover,
        width: double.infinity,
      ),
    );
  }

  Widget _buildVideoWidget(Files file) {
    final videoUrl = _getVideoUrl(file.video);
    if (videoUrl == null) {
      return SizedBox.shrink();
    }

    return VideoPlayerProvider(
      key: Key(videoUrl),
      tag: videoUrl,
      autoPlay: false,
      videoUrl: videoUrl,
      videoDetail: Vod(0, ''),
      loadingWidget: AspectRatio(
        aspectRatio: 16 / 9,
        child: VideoLoading(coverHorizontal: file.cover),
      ),
      child: (isReady, controller) {
        return VideoPlayerArea(
          name: '',
          videoUrl: videoUrl,
          video: Vod(0, ''),
          tag: videoUrl,
        );
      },
    );
  }

  Widget _buildUnlockButton(
      BuildContext context, PostController postController) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Button(
        text: '解鎖更多內容',
        onPressed: () {
          if (postDetail.chargeType == ChargeType.vip.index) {
            MyRouteDelegate.of(context).push(AppRoutes.vip);
          } else {
            postController.getPostDetail(postDetail.id);
            purchase(
              context,
              type: PurchaseType.post,
              id: postDetail.id,
              onSuccess: () => postController.getPostDetail(postDetail.id),
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
      fileWidgets.add(_buildUnlockButton(context, postController));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: fileWidgets,
    );
  }
}
