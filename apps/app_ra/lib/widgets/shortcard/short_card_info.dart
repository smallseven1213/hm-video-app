import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/short_video_detail_controller.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/models/short_video_detail.dart';
import 'package:shared/modules/short_video/short_video_consumer.dart';
import 'package:shared/modules/video_player/video_player_consumer.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/enums/charge_type.dart';

import '../../utils/purchase.dart';
import '../actor_avatar.dart';
import 'short_card_info_tag.dart';
import 'video_progress.dart';

class ShortCardInfo extends StatelessWidget {
  final ShortVideoDetail data;
  final String title;
  final String tag;
  final bool showAvatar;

  const ShortCardInfo({
    Key? key,
    required this.data,
    required this.title,
    required this.tag,
    this.showAvatar = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VideoPlayerConsumer(
        tag: tag,
        child: (VideoPlayerInfo videoPlayerInfo) {
          return Container(
            width: MediaQuery.of(context).size.width,
            // 做垂直漸層, 底部全透明，上面為Colors.black.withOpacity(0.5)
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.5),
                  Colors.transparent,
                ],
              ),
            ),
            // margin bottom 10
            margin: const EdgeInsets.only(bottom: 5),
            padding:
                const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (data.supplier != null) ...[
                  GestureDetector(
                    onTap: () async {
                      videoPlayerInfo
                          .observableVideoPlayerController.videoPlayerController
                          ?.pause();
                      await MyRouteDelegate.of(context)
                          .push(AppRoutes.supplier, args: {
                        'id': data.supplier!.id,
                      });
                      videoPlayerInfo
                          .observableVideoPlayerController.videoPlayerController
                          ?.play();
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        showAvatar == true
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(right: 8, bottom: 8),
                                child: ActorAvatar(
                                  photoSid: data.supplier!.photoSid,
                                  width: 40,
                                  height: 40,
                                ))
                            : const SizedBox(),
                        Text(
                            '${showAvatar == true ? '' : '@'}${data.supplier!.aliasName}',
                            style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFFFDDCEF),
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                      ],
                    ),
                  )
                ],
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                if (data.tag.isNotEmpty) ...[
                  Wrap(
                    direction: Axis.horizontal,
                    spacing: 4,
                    runSpacing: 4,
                    children: data.tag
                        .map((e) => GestureDetector(
                            onTap: () async {
                              videoPlayerInfo.observableVideoPlayerController
                                  .videoPlayerController
                                  ?.pause();
                              await MyRouteDelegate.of(context).push(
                                AppRoutes.tag,
                                args: {
                                  'id': e.id,
                                  'title': e.name,
                                  'defaultTabIndex': 1
                                },
                                removeSamePath: true,
                              );
                              videoPlayerInfo.observableVideoPlayerController
                                  .videoPlayerController
                                  ?.play();
                            },
                            child: ShortCardInfoTag(name: '#${e.name}')))
                        .toList(),
                  ),
                  const SizedBox(height: 10)
                ],
                ShortVideoConsumer(
                    vodId: data.id,
                    tag: tag,
                    child: ({
                      required isLoading,
                      required video,
                      required videoDetail,
                      required videoUrl,
                    }) =>
                        !video!.isAvailable
                            ? video.chargeType == ChargeType.vip.index
                                ? InkWell(
                                    onTap: () => MyRouteDelegate.of(context)
                                        .push(AppRoutes.vip),
                                    child: const Text('開通 VIP 無限看片',
                                        style: TextStyle(
                                            color: Color(0xFFFDDCEF),
                                            fontSize: 16)),
                                  )
                                : VideoPlayerConsumer(
                                    tag: tag,
                                    child: (VideoPlayerInfo videoPlayerInfo) {
                                      return InkWell(
                                        onTap: () => purchase(
                                          context,
                                          id: video.id,
                                          onSuccess: () {
                                            final ShortVideoDetailController
                                                shortVideoDetailController =
                                                Get.find<
                                                        ShortVideoDetailController>(
                                                    tag: tag);
                                            shortVideoDetailController
                                                .mutateAll();
                                            // videoPlayerInfo
                                            //     .videoPlayerController
                                            //     ?.play();
                                          },
                                        ),
                                        child: Text(
                                          '${video.buyPoint}金幣解鎖',
                                          style: const TextStyle(
                                              color: Color(0xFFFDDCEF),
                                              fontSize: 16),
                                        ),
                                      );
                                    })
                            : const SizedBox()),
                const SizedBox(height: 10),
                VideoProgressWidget(
                  tag: tag,
                  videoId: data.id,
                  videoPlayerController: videoPlayerInfo.videoPlayerController!,
                ),
              ],
            ),
          );
        });
  }
}
