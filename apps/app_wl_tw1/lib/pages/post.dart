import 'package:app_wl_tw1/widgets/button.dart';
import 'package:app_wl_tw1/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/system_config_controller.dart';
import 'package:shared/enums/app_routes.dart';
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
import 'package:shared/widgets/video/purchase_promotion.dart';

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
                  SerialListWidget(series: postDetail.series),
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

  String? getVideoUrl(String videoUrl) {
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

  @override
  Widget build(BuildContext context) {
    List<Widget> fileWidgets = [];
    final int maxPreviewMediaCount = postDetail.previewMediaCount;

    for (int i = 0; i < postDetail.files.length; i++) {
      if (i < maxPreviewMediaCount) {
        final file = postDetail.files[i];
        final videoUrl = getVideoUrl(file.video);

        if (file.type == 1) {
          fileWidgets.add(Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: SidImage(sid: file.cover),
          ));
        } else if (file.type == 2) {
          if (videoUrl == null) {
            continue;
          }
          fileWidgets.add(VideoPlayerProvider(
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
          ));
        }
      } else if (i == maxPreviewMediaCount) {
        fileWidgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Button(
              text: '解鎖更多內容',
              onPressed: () {
                if (postDetail.chargeType == ChargeType.vip.index) {
                  // VIP
                  MyRouteDelegate.of(context).push(AppRoutes.vip);
                } else {
                  // 金幣
                  print('金幣付費解鎖');
                }
              },
            ),
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: fileWidgets,
    );
  }
}
