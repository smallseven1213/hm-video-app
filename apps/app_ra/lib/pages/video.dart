import 'package:app_ra/utils/purchase.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared/apis/user_api.dart';
import 'package:shared/apis/vod_api.dart';
import 'package:shared/controllers/video_detail_controller.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/enums/charge_type.dart';
import 'package:shared/models/vod.dart';
import 'package:shared/modules/user/watch_permission_provider.dart';
import 'package:shared/modules/video/video_provider.dart';
import 'package:shared/modules/video_player/video_player_consumer.dart';
import 'package:shared/modules/video_player/video_player_provider.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/widgets/video/index.dart';
import 'package:shared/widgets/video/loading.dart';
import '../config/colors.dart';
import '../screens/video/nested_tab_bar_view/index.dart';
import '../utils/show_confirm_dialog.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/wave_loading.dart';

final userApi = UserApi();

class Video extends StatefulWidget {
  final Map<String, dynamic> args;

  const Video({Key? key, required this.args}) : super(key: key);

  @override
  VideoState createState() => VideoState();
}

const gridRatio = 128 / 227;
final vodApi = VodApi();

class VideoState extends State<Video> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.black));
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var id = int.parse(widget.args['id'].toString());

    var name = widget.args['name'];
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
          appBar: CustomAppBar(
            titleWidget: !videoDetail!.isAvailable
                ? videoDetail.chargeType == ChargeType.vip.index
                    ? Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () => MyRouteDelegate.of(context).push(AppRoutes.vip),
                          child: Text(
                            '開通 VIP 無限看片',
                            style: TextStyle(
                              fontSize: 15,
                              color: AppColors.colors[ColorKeys.textPrimary],
                            ),
                          ),
                        ),
                      )
                    : VideoPlayerConsumer(
                        tag: videoUrl,
                        child: (VideoPlayerInfo videoPlayerInfo) {
                          return Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                onTap: () => purchase(
                                  context,
                                  id: id,
                                  onSuccess: () {
                                    final videoDetailController = Get.find<VideoDetailController>(tag: videoUrl);
                                    videoDetailController.mutateAll();
                                    videoPlayerInfo.videoPlayerController?.play();
                                  },
                                ),
                                child: Text(
                                  '${videoDetail.buyPoint}金幣解鎖',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: AppColors.colors[ColorKeys.textPrimary],
                                  ),
                                ),
                              ));
                        })
                : const SizedBox(),
          ),
          body: SafeArea(
            child: WatchPermissionProvider(
              showConfirmDialog: () {
                showConfirmDialog(
                  context: context,
                  message: '請先登入後觀看。',
                  cancelButtonText: '返回',
                  barrierDismissible: false,
                  onConfirm: () => MyRouteDelegate.of(context).push(AppRoutes.login),
                  onCancel: () => MyRouteDelegate.of(context).popToHome(),
                );
              },
              child: (canWatch) => Column(
                children: [
                  VideoPlayerProvider(
                    key: Key(videoUrl),
                    tag: videoUrl,
                    autoPlay: canWatch,
                    videoUrl: videoUrl,
                    videoDetail: videoDetail,
                    loadingWidget: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(
                        color: Colors.black,
                        child: VideoLoading(
                          coverHorizontal: videoDetail.coverHorizontal ?? '',
                          loadingAnimation: CircularProgressIndicator(
                            color: AppColors.colors[ColorKeys.textPrimary],
                          ),
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
                          loadingAnimation: CircularProgressIndicator(
                            color: AppColors.colors[ColorKeys.textPrimary],
                          ),
                        ),
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
          ),
        );
      },
    );
  }
}
