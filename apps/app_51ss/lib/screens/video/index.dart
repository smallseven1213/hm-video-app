import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/models/vod.dart';
import 'package:shared/modules/user/watch_permission_provider.dart';
import 'package:shared/modules/video/video_provider.dart';
import 'package:shared/modules/video_player/video_player_provider.dart';
import 'package:shared/navigator/delegate.dart';

import '../../config/colors.dart';
import '../../utils/show_confirm_dialog.dart';
import 'nested_tab_bar_view/index.dart';
import 'video_player_area/flash_loading.dart';
import 'video_player_area/index.dart';
import 'video_player_area/loading.dart';

final logger = Logger();

class VideoScreen extends StatefulWidget {
  final int id;
  final String? name;

  const VideoScreen({
    Key? key,
    required this.id,
    this.name,
  }) : super(key: key);

  @override
  VideoScreenState createState() => VideoScreenState();
}

class VideoScreenState extends State<VideoScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.black));
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: AppColors.colors[ColorKeys.primary]),
      child: VideoScreenProvider(
        id: widget.id,
        name: widget.name,
        child: ({
          required String? videoUrl,
          required Vod? videoDetail,
        }) {
          if (videoUrl == null) {
            return const Center(child: FlashLoading());
          }

          return SafeArea(
            child: WatchPermissionProvider(
              showConfirmDialog: () {
                showConfirmDialog(
                  context: context,
                  message: '請先登入後觀看。',
                  barrierDismissible: false,
                  onConfirm: () {
                    MyRouteDelegate.of(context).push(AppRoutes.login);
                  },
                  onCancel: () {
                    MyRouteDelegate.of(context).push(AppRoutes.home);
                  },
                );
              },
              child: (canWatch) => Column(
                children: [
                  VideoPlayerProvider(
                    tag: videoUrl,
                    autoPlay: canWatch,
                    video: videoDetail!,
                    videoUrl: videoUrl,
                    videoDetail: videoDetail,
                    loadingWidget: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(
                        color: Colors.black,
                        child: VideoLoading(
                            coverHorizontal: videoDetail.coverHorizontal ?? ''),
                      ),
                    ),
                    child: (isReady, controller) {
                      return VideoPlayerArea(
                        name: widget.name,
                        videoUrl: videoUrl,
                        video: videoDetail,
                      );
                    },
                  ),
                  Expanded(
                    child: NestedTabBarView(
                      videoUrl: videoUrl,
                      videoDetail: videoDetail,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
