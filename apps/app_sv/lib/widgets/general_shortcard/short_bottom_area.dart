import 'package:app_sv/config/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/user_favorites_short_controlle.dart';
import 'package:shared/controllers/user_short_collection_controller.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/models/vod.dart';
import 'package:shared/modules/short_video/short_video_collect_count_consumer.dart';
import 'package:shared/modules/short_video/short_video_favorite_count_consumer.dart';
import 'package:shared/widgets/ui_bottom_safearea.dart';

import '../../screens/short/button.dart';

final logger = Logger();

class ShortBottomArea extends StatelessWidget {
  final Vod shortData;
  final String tag;
  final bool? displayFavoriteAndCollectCount;

  const ShortBottomArea({
    Key? key,
    required this.shortData,
    required this.tag,
    this.displayFavoriteAndCollectCount = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userShortCollectionController =
        Get.find<UserShortCollectionController>();
    final userFavoritesShortController =
        Get.find<UserFavoritesShortController>();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black,
            AppColors.colors[ColorKeys.buttonBgPrimary]!,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: UIBottomSafeArea(
        child: SizedBox(
          height: 76,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ShortVideoFavoriteCountConsumer(
                  videoId: shortData.id,
                  tag: tag,
                  child: (favoriteCount, update) => Obx(() {
                        bool isLike = userFavoritesShortController.data
                            .any((e) => e.id == shortData.id);
                        return ShortMenuButton(
                          key: Key(
                              'short_bottom_area_like_button ${shortData.id}'),
                          displayFavoriteAndCollectCount:
                              displayFavoriteAndCollectCount,
                          count: favoriteCount,
                          subscribe: '喜歡就點讚',
                          icon: Icons.favorite_rounded,
                          isLike: isLike,
                          onTap: () {
                            if (isLike) {
                              userFavoritesShortController
                                  .removeVideo([shortData.id]);
                              if (favoriteCount > 0) {
                                update(-1);
                              }
                            } else {
                              userFavoritesShortController.addVideo(shortData);
                              update(1);
                            }
                          },
                        );
                      })),
              ShortVideoCollectCountConsumer(
                  videoId: shortData.id,
                  tag: tag,
                  child: ((collectCount, update) => Obx(() {
                        bool isLike = userShortCollectionController.data
                            .any((e) => e.id == shortData.id);
                        return ShortMenuButton(
                          key: Key(
                              'short_bottom_area_collection_button ${shortData.id}'),
                          displayFavoriteAndCollectCount:
                              displayFavoriteAndCollectCount,
                          count: collectCount,
                          subscribe: '添加到收藏',
                          icon: Icons.star_rounded,
                          iconSize: 30,
                          isLike: isLike,
                          onTap: () {
                            if (isLike) {
                              userShortCollectionController
                                  .removeVideo([shortData.id]);
                              if (collectCount > 0) {
                                update(-1);
                              }
                            } else {
                              userShortCollectionController.addVideo(shortData);
                              update(1);
                            }
                          },
                        );
                      }))),
            ],
          ),
        ),
      ),
    );
  }
}
