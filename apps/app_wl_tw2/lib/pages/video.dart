import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared/apis/user_api.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/models/vod.dart';
import 'package:shared/modules/user/watch_permission_provider.dart';
import 'package:shared/modules/video/video_provider.dart';
import 'package:shared/modules/video_player/video_player_provider.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/widgets/video/index.dart';
import 'package:shared/widgets/video/loading.dart';
import 'package:shared/widgets/video/purchase_block.dart';
import '../screens/video/nested_tab_bar_view/index.dart';
import '../utils/show_confirm_dialog.dart';
import '../widgets/wave_loading.dart';
import '../config/colors.dart';
import 'package:app_wl_tw2/widgets/flash_loading.dart';
import 'package:app_wl_tw2/localization/i18n.dart';

final userApi = UserApi();

class Video extends StatefulWidget {
  final Map<String, dynamic> args;

  const Video({Key? key, required this.args}) : super(key: key);

  @override
  VideoState createState() => VideoState();
}

class VideoState extends State<Video> {
  @override
  Widget build(BuildContext context) {
    var id = int.parse(widget.args['id'].toString());
    var name = widget.args['name'];
    final Map<String, ImageProvider<Object>> images = {
      'img-vip': const AssetImage('assets/images/purchase/img-vip.png'),
      'icon-vip': const AssetImage('assets/images/purchase/icon-vip.webp'),
      'img-coin': const AssetImage('assets/images/purchase/img-coin.png'),
      'icon-coin': const AssetImage('assets/images/purchase/icon-coin.webp'),
    };
    return VideoScreenProvider(
      id: id,
      name: name,
      child: ({
        required String? videoUrl,
        required Vod? videoDetail,
      }) {
        if (videoUrl == null) {
          return const WaveLoading();
        }

        return Scaffold(
          body: SafeArea(
            child: WatchPermissionProvider(showConfirmDialog: () {
              showConfirmDialog(
                context: context,
                message: I18n.plsLoginToWatch,
                cancelButtonText: I18n.back,
                barrierDismissible: false,
                onConfirm: () => MyRouteDelegate.of(context).push(AppRoutes.login),
                onCancel: () => MyRouteDelegate.of(context).popToHome(),
              );
            }, child: (canWatch) {
              return Column(
                children: [
                  VideoPlayerProvider(
                    key: Key(videoUrl),
                    tag: videoUrl,
                    autoPlay: canWatch,
                    videoUrl: videoUrl,
                    videoDetail: videoDetail!,
                    loadingWidget: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(
                        color: Colors.black,
                        child: VideoLoading(
                          coverHorizontal: videoDetail.coverHorizontal ?? '',
                          loadingAnimation: const FlashLoading(),
                        ),
                      ),
                    ),
                    child: (isReady, controller) {
                      return VideoPlayerWidget(
                        name: name,
                        videoUrl: videoUrl,
                        video: videoDetail,
                        tag: videoUrl,
                        showConfirmDialog: showConfirmDialog,
                        themeColor: AppColors.colors[ColorKeys.secondary],
                        buildLoadingWidget: VideoLoading(
                          coverHorizontal: videoDetail.coverHorizontal ?? '',
                          loadingAnimation: const FlashLoading(),
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
                      showConfirmDialog: showConfirmDialog,
                      images: images,
                    ),
                  Expanded(
                    child: NestedTabBarView(
                      videoUrl: videoUrl,
                      videoDetail: videoDetail,
                    ),
                  )
                ],
              );
            }),
          ),
        );
      },
    );
  }
}
