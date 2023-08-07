import 'package:app_gs/widgets/actor_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/short_video_detail_controller.dart';
import 'package:shared/controllers/user_favorites_short_controlle.dart';
import 'package:shared/controllers/user_short_collection_controller.dart';
import 'package:shared/controllers/video_player_controller.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/models/vod.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/utils/controller_tag_genarator.dart';
import 'package:shared/utils/video_info_formatter.dart';

import '../../config/colors.dart';

final logger = Logger();

class SideInfo extends StatelessWidget {
  final String obsKey;
  final Vod shortData;

  const SideInfo({
    Key? key,
    required this.obsKey,
    required this.shortData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final obsVideoPlayerController =
        Get.find<ObservableVideoPlayerController>(tag: obsKey);
    final ShortVideoDetailController videoDetailController =
        Get.find<ShortVideoDetailController>(
            tag: genaratorShortVideoDetailTag(shortData.id.toString()));

    final userShortCollectionController =
        Get.find<UserShortCollectionController>();
    final userFavoritesShortController =
        Get.find<UserFavoritesShortController>();

    return Positioned(
      right: 8,
      top: MediaQuery.of(context).size.height * 0.5 - 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 供應商
          Obx(() {
            var data = videoDetailController.videoDetail.value;

            if (data?.supplier != null) {
              return GestureDetector(
                onTap: () async {
                  obsVideoPlayerController.pause();
                  await MyRouteDelegate.of(context)
                      .push(AppRoutes.supplier, args: {
                    'id': data?.supplier!.id,
                  });
                  obsVideoPlayerController.play();
                },
                child: ActorAvatar(
                  photoSid: data?.supplier!.photoSid,
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

          Obx(() {
            bool isLike = userFavoritesShortController.data
                .any((e) => e.id == shortData.id);
            var favorites = videoDetailController.videoFavorites.value;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(right: 1),
                  onPressed: () {
                    logger.i(
                        '===== LIKE ===== $isLike ${shortData.id}} $favorites');
                    if (isLike) {
                      userFavoritesShortController.removeVideo([shortData.id]);
                      if (favorites > 0) {
                        videoDetailController.updateFavorites(-1);
                      }
                    } else {
                      var vod = Vod.fromJson(shortData.toJson());
                      userFavoritesShortController.addVideo(vod);
                      videoDetailController.updateFavorites(1);
                    }
                  },
                  icon: Icon(
                    Icons.favorite_rounded,
                    size: 30,
                    color: isLike ? Colors.red : Colors.white,
                  ),
                ),
                Text(
                  formatNumberToUnit(favorites,
                      shouldCalculateThousands: false),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
              ],
            );
          }),

          // 收藏

          const SizedBox(height: 10),

          Obx(() {
            bool isLike = userShortCollectionController.data
                .any((e) => e.id == shortData.id);
            var collects = videoDetailController.videoCollects.value;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  padding: const EdgeInsets.only(right: 1),
                  onPressed: () {
                    if (isLike) {
                      userShortCollectionController.removeVideo([shortData.id]);
                      if (collects > 0) {
                        videoDetailController.updateCollects(-1);
                      }
                    } else {
                      var vod = Vod.fromJson(shortData.toJson());
                      userShortCollectionController.addVideo(vod);
                      videoDetailController.updateCollects(1);
                    }
                  },
                  icon: Icon(
                    Icons.star_rounded,
                    size: 36,
                    color: isLike
                        ? AppColors.colors[ColorKeys.primary]
                        : Colors.white,
                  ),
                ),
                Text(
                  formatNumberToUnit(collects, shouldCalculateThousands: false),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
