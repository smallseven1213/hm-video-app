import 'package:app_wl_tw1/widgets/actor_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/user_favorites_short_controlle.dart';
import 'package:shared/controllers/user_short_collection_controller.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/models/vod.dart';
import 'package:shared/modules/short_video/short_video_collect_count_consumer.dart';
import 'package:shared/modules/short_video/short_video_detail.dart';
import 'package:shared/modules/short_video/short_video_favorite_count_consumer.dart';
import 'package:shared/modules/video_player/video_player_consumer.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/utils/controller_tag_genarator.dart';
import 'package:shared/utils/video_info_formatter.dart';

import '../../config/colors.dart';

final logger = Logger();

class SideInfo extends StatefulWidget {
  final int videoId;
  final Vod shortData;
  final String tag;

  const SideInfo({
    Key? key,
    required this.videoId,
    required this.shortData,
    required this.tag,
  }) : super(key: key);

  @override
  _SideInfoState createState() => _SideInfoState();
}

class _SideInfoState extends State<SideInfo> {
  @override
  Widget build(BuildContext context) {
    final userShortCollectionController =
        Get.find<UserShortCollectionController>();
    final userFavoritesShortController =
        Get.find<UserFavoritesShortController>();

    return VideoPlayerConsumer(
        tag: widget.tag,
        child: (VideoPlayerInfo videoPlayerInfo) {
          return Positioned(
            right: 8,
            top: MediaQuery.sizeOf(context).height * 0.5 - 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShortVideoDetailConsumer(
                    videoId: widget.videoId,
                    tag: widget.tag,
                    child: (videoDetail) {
                      if (videoDetail?.supplier != null) {
                        return GestureDetector(
                          onTap: () async {
                            videoPlayerInfo.observableVideoPlayerController
                                .videoPlayerController
                                ?.pause();
                            await MyRouteDelegate.of(context)
                                .push(AppRoutes.supplier, args: {
                              'id': videoDetail?.supplier!.id,
                            });
                            videoPlayerInfo.observableVideoPlayerController
                                .videoPlayerController
                                ?.play();
                          },
                          child: ActorAvatar(
                            photoSid: videoDetail?.supplier!.photoSid,
                            width: 45,
                            height: 45,
                          ),
                        );
                      } else {
                        return Container();
                      }
                    }),
                const SizedBox(height: 20),
                // 按讚
                ShortVideoFavoriteCountConsumer(
                    videoId: widget.videoId,
                    tag: widget.tag,
                    child: (favoriteCount, update) => Obx(() {
                          bool isLike = userFavoritesShortController.data
                              .any((e) => e.id == widget.shortData.id);

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.only(right: 1),
                                onPressed: () {
                                  if (isLike) {
                                    userFavoritesShortController
                                        .removeVideo([widget.shortData.id]);
                                    if (favoriteCount > 0) {
                                      update(-1);
                                    }
                                  } else {
                                    var vod =
                                        Vod.fromJson(widget.shortData.toJson());
                                    userFavoritesShortController.addVideo(vod);
                                    update(1);
                                  }
                                },
                                icon: Icon(
                                  Icons.favorite_rounded,
                                  size: 30,
                                  color: isLike ? Colors.red : Colors.white,
                                ),
                              ),
                              Text(
                                formatNumberToUnit(favoriteCount,
                                    shouldCalculateThousands: false),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          );
                        })),
                // 收藏
                const SizedBox(height: 10),
                ShortVideoCollectCountConsumer(
                    videoId: widget.videoId,
                    tag: widget.tag,
                    child: ((collectCount, update) => Obx(() {
                          bool isLike = userShortCollectionController.data
                              .any((e) => e.id == widget.shortData.id);

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                padding: const EdgeInsets.only(right: 1),
                                onPressed: () {
                                  if (isLike) {
                                    userShortCollectionController
                                        .removeVideo([widget.shortData.id]);
                                    if (collectCount > 0) {
                                      update(-1);
                                    }
                                  } else {
                                    var vod =
                                        Vod.fromJson(widget.shortData.toJson());
                                    userShortCollectionController.addVideo(vod);
                                    update(1);
                                  }
                                },
                                icon: Icon(
                                  Icons.star_rounded,
                                  size: 36,
                                  color: isLike
                                      ? Colors.yellow.shade700
                                      : Colors.white,
                                ),
                              ),
                              Text(
                                formatNumberToUnit(collectCount,
                                    shouldCalculateThousands: false),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          );
                        }))),
              ],
            ),
          );
        });
  }
}
