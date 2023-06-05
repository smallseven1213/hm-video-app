import 'package:app_gs/screens/video/video_player_area/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/video_detail_controller.dart';
import 'package:shared/controllers/video_player_controller.dart';
import 'package:shared/utils/controller_tag_genarator.dart';

import 'nested_tab_bar_view/index.dart';
import '../../widgets/custom_app_bar.dart';

final logger = Logger();

class VideoScreen extends StatelessWidget {
  final int id;
  final String? name;

  const VideoScreen({
    Key? key,
    required this.id,
    this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controllerTag = genaratorLongVideoDetailTag(id.toString());

    if (!Get.isRegistered(tag: controllerTag)) {
      Get.lazyPut<VideoDetailController>(() => VideoDetailController(id),
          tag: controllerTag);
    }

    final controller = Get.find<VideoDetailController>(tag: controllerTag);

    return FutureBuilder(
      future: controller.videoUrlReady,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            logger
                .i('LOGN VIDEO TRACE: VIDEO URL: ${controller.videoUrl.value}');
            if (!Get.isRegistered(
              tag: controller.videoUrl.value,
            )) {
              Get.lazyPut<ObservableVideoPlayerController>(
                () =>
                    ObservableVideoPlayerController(controller.videoUrl.value),
                tag: controller.videoUrl.value,
              );
            }

            var videoDetail = controller.videoDetail.value;
            var video = controller.video.value;
            return Column(
              children: [
                video != null
                    ? VideoPlayerArea(
                        name: name,
                        videoUrl: controller.videoUrl.value,
                        video: video,
                      )
                    : AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Container(
                          color: Colors.black,
                          child: CustomAppBar(
                            title: name ?? '',
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                      ),
                Expanded(
                  child: video != null && videoDetail != null
                      ? NestedTabBarView(
                          videoUrl: controller.videoUrl.value,
                          videoBase: video,
                          videoDetail: videoDetail,
                        )
                      : const Center(
                          child: CircularProgressIndicator(),
                        ),
                )
              ],
            );
          }
        } else {
          return Container();
        }
      },
    );
  }
}
