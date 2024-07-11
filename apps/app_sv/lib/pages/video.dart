import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared/apis/user_api.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/models/vod.dart';
import 'package:shared/modules/user/watch_permission_provider.dart';
import 'package:shared/modules/video/video_provider.dart';
import 'package:shared/modules/video_player/video_player_provider.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/utils/controller_tag_genarator.dart';
import '../screens/video/nested_tab_bar_view/index.dart';
import '../screens/video/video_player_area/index.dart';
import '../screens/video/video_player_area/loading.dart';
import '../screens/video/video_player_area/purchase_block.dart';
import '../utils/show_confirm_dialog.dart';
import '../widgets/wave_loading.dart';

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
    final controllerTag = genaratorLongVideoDetailTag(id.toString());

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
          body: SafeArea(
            child: WatchPermissionProvider(
              showConfirmDialog: () {
                showConfirmDialog(
                  context: context,
                  message: '請先登入後觀看。',
                  barrierDismissible: false,
                  showCancelButton: false,
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
                            coverHorizontal: videoDetail.coverHorizontal ?? ''),
                      ),
                    ),
                    child: (isReady, controller) {
                      return VideoPlayerArea(
                        name: name,
                        videoUrl: videoUrl,
                        video: videoDetail,
                        tag: controllerTag,
                      );
                    },
                  ),
                  if (videoDetail.isAvailable == false)
                    PurchaseBlock(
                      id: id.toString(),
                      videoDetail: videoDetail,
                      videoUrl: videoUrl,
                      tag: controllerTag,
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
