import 'package:app_wl_id1/screens/video/video_player_area/index.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/models/vod.dart';
import 'package:shared/modules/video/video_provider.dart';
import 'package:shared/modules/video_player/video_player_provider.dart';
import 'package:shared/modules/user/watch_permission_provider.dart';
import 'package:shared/navigator/delegate.dart';

import '../../localization/i18n.dart';
import '../../utils/show_confirm_dialog.dart';
import '../../widgets/wave_loading.dart';
import 'nested_tab_bar_view/index.dart';
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
    return VideoScreenProvider(
      id: widget.id,
      name: widget.name,
      child: ({
        required String? videoUrl,
        required Vod? videoDetail,
      }) {
        if (videoUrl == null) {
          return const WaveLoading();
        }

        return SafeArea(
          child: WatchPermissionProvider(
            showConfirmDialog: () {
              showConfirmDialog(
                context: context,
                message: I18n.plsLoginToWatch,
                barrierDismissible: false,
                showCancelButton: false,
                onConfirm: () {
                  MyRouteDelegate.of(context).push(AppRoutes.login);
                },
              );
            },
            child: (canWatch) {
              return Column(
                children: [
                  VideoPlayerProvider(
                    tag: videoUrl,
                    autoPlay: kIsWeb ? false : canWatch,
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
              );
            },
          ),
        );
      },
    );
  }
}
