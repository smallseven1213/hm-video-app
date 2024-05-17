import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_wl_tw2/widgets/actor_avatar.dart';

import 'package:shared/enums/app_routes.dart';
import 'package:shared/controllers/short_video_detail_controller.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/models/short_video_detail.dart';
import 'package:shared/modules/video_player/video_player_consumer.dart';
import 'package:shared/modules/short_video/short_video_consumer.dart';
import 'package:shared/utils/video_info_formatter.dart';

import '../../screens/short/short_card_info_tag.dart';
import '../../screens/video/video_player_area/enums.dart';
import '../../utils/purchase.dart';

final logger = Logger();

class ShortCardInfo extends StatelessWidget {
  final ShortVideoDetail data;
  final String title;
  final String tag;
  final bool displayActorAvatar;
  final String videoUrl;

  const ShortCardInfo({
    Key? key,
    required this.data,
    required this.title,
    required this.tag,
    this.displayActorAvatar = true,
    required this.videoUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VideoPlayerConsumer(
        tag: videoUrl,
        child: (VideoPlayerInfo videoPlayerInfo) {
          return Container(
            width: MediaQuery.sizeOf(context).width,
            padding: const EdgeInsets.all(10),
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
                        displayActorAvatar == true
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
                            '${displayActorAvatar == true ? '' : '@'}${data.supplier!.aliasName}',
                            style: TextStyle(
                              fontSize: displayActorAvatar == true ? 13 : 15,
                              color: Colors.white,
                            )),
                        const SizedBox(height: 8),
                      ],
                    ),
                  )
                ],
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
                if (data.tag.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Wrap(
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
                                  AppRoutes.supplierTag,
                                  args: {'tagId': e.id, 'tagName': e.name},
                                );
                                videoPlayerInfo.observableVideoPlayerController
                                    .videoPlayerController
                                    ?.play();
                              },
                              child: ShortCardInfoTag(name: '#${e.name}')))
                          .toList(),
                    ),
                  ),
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
                                    child: Stack(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.only(
                                            right: 10,
                                            left: 30,
                                            top: 5,
                                            bottom: 5,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            border: Border.all(
                                              color: const Color(0xffcecece)
                                                  .withOpacity(0.7),
                                              width: 1,
                                            ),
                                          ),
                                          child: Text(
                                            '升級觀看完整版 ${getTimeString(video.timeLength)}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        const Positioned(
                                          top: -1,
                                          left: -1,
                                          child: Image(
                                            image: AssetImage(
                                                'assets/images/purchase/icon-short-vip.webp'),
                                            width: 25,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : InkWell(
                                    onTap: () => purchase(
                                      context,
                                      id: video.id,
                                      onSuccess: () {
                                        final ShortVideoDetailController
                                            shortVideoDetailController =
                                            Get.find<
                                                    ShortVideoDetailController>(
                                                tag: tag);
                                        shortVideoDetailController.mutateAll();
                                      },
                                    ),
                                    child: Stack(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.only(
                                            right: 10,
                                            left: 35,
                                            top: 5,
                                            bottom: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            border: Border.all(
                                              color: const Color(0xffe7b400),
                                              width: 1,
                                            ),
                                          ),
                                          child: Text(
                                            '${video.buyPoint} 金幣購買完整版 ${getTimeString(video.timeLength)}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        const Positioned(
                                          top: -1,
                                          left: -1,
                                          child: Image(
                                            image: AssetImage(
                                                'assets/images/purchase/icon-short-coin.webp'),
                                            width: 30,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                            : const SizedBox()),
              ],
            ),
          );
        });
  }
}
