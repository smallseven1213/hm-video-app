import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/models/vod.dart';
import 'package:shared/modules/video/video_provider.dart';
import 'package:shared/modules/video_player/video_player_provider.dart';
import 'package:shared/modules/user/watch_permission_provider.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/widgets/video/index.dart';
import 'package:shared/widgets/video/loading.dart';
import 'package:shared/widgets/video/purchase_block.dart';

import '../../localization/i18n.dart';
import '../../utils/show_confirm_dialog.dart';
import '../../widgets/wave_loading.dart';
import '../../config/colors.dart';
import 'nested_tab_bar_view/index.dart';
import 'dot_line_animation.dart';

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
    var id = int.parse(widget.id.toString());
    final Map<String, ImageProvider<Object>> images = {
      'img-vip': const AssetImage('assets/images/purchase/img-vip.png'),
      'icon-vip': const AssetImage('assets/images/purchase/icon-vip.webp'),
      'img-coin': const AssetImage('assets/images/purchase/img-coin.png'),
      'icon-coin': const AssetImage('assets/images/purchase/icon-coin.webp'),
    };
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
                cancelButtonText: I18n.back,
                barrierDismissible: false,
                onConfirm: () =>
                    MyRouteDelegate.of(context).push(AppRoutes.login),
                onCancel: () => MyRouteDelegate.of(context).popToHome(),
              );
            },
            child: (canWatch) {
              return Column(
                children: [
                  VideoPlayerProvider(
                    key: Key(videoUrl),
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
                          coverHorizontal: videoDetail.coverHorizontal ?? '',
                          image: const Image(
                              image: AssetImage('assets/images/logo.png'),
                              width: 60.0),
                          loadingAnimation: const DotLineAnimation(),
                        ),
                      ),
                    ),
                    child: (isReady, controller) {
                      return VideoPlayerWidget(
                        name: widget.name,
                        videoUrl: videoUrl,
                        video: videoDetail,
                        tag: videoUrl,
                        showConfirmDialog: showConfirmDialog,
                        themeColor: AppColors.colors[ColorKeys.secondary],
                        buildLoadingWidget: VideoLoading(
                          coverHorizontal: videoDetail.coverHorizontal ?? '',
                          image: const Image(
                              image: AssetImage('assets/images/logo.png'),
                              width: 60.0),
                          loadingAnimation: const DotLineAnimation(),
                        ),
                      );
                    },
                  ),
                  if (videoDetail.isAvailable == false)
                    PurchaseBlock(
                      id: id,
                      videoDetail: videoDetail,
                      videoUrl: videoUrl,
                      tag: videoUrl,
                      images: images,
                      showConfirmDialog: showConfirmDialog,
                      useGameDeposit: true,
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
