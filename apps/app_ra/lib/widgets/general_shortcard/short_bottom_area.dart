import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/user_favorites_short_controlle.dart';
import 'package:shared/controllers/user_short_collection_controller.dart';
import 'package:shared/models/vod.dart';
import 'package:shared/modules/short_video/short_video_collect_count_consumer.dart';
import 'package:shared/modules/short_video/short_video_favorite_count_consumer.dart';

import '../short/button.dart';

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
    final paddingBottom = MediaQuery.of(context).padding.bottom;
    final userShortCollectionController =
        Get.find<UserShortCollectionController>();
    final userFavoritesShortController =
        Get.find<UserFavoritesShortController>();

    return Container(
      height: 76 + paddingBottom,
      padding: EdgeInsets.only(bottom: paddingBottom),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black,
            Color(0xFF002869),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(
            width: 10,
          ),
          ShortVideoFavoriteCountConsumer(
              videoId: shortData.id,
              tag: tag,
              child: (favoriteCount, update) => Obx(() {
                    bool isLike = userFavoritesShortController.data
                        .any((e) => e.id == shortData.id);
                    return ShortMenuButton(
                      key: Key('short_bottom_area_like_button ${shortData.id}'),
                      displayFavoriteAndCollectCount:
                          displayFavoriteAndCollectCount,
                      count: favoriteCount,
                      subscribe: '喜歡就點讚',
                      icon: Icons.favorite_outline_rounded,
                      isLike: isLike,
                      onTap: () {
                        if (isLike) {
                          userFavoritesShortController
                              .removeVideo([shortData.id]);
                          if (favoriteCount > 0) {
                            update(-1);
                          }
                        } else {
                          var vod = Vod.fromJson(shortData.toJson());
                          userFavoritesShortController.addVideo(vod);
                          update(1);
                        }
                      },
                    );
                  })),
          const SizedBox(
            width: 10,
          ),
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
                      icon: Icons.bookmark_border_outlined,
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
                          var vod = Vod.fromJson(shortData.toJson());
                          userShortCollectionController.addVideo(vod);
                          update(1);
                        }
                      },
                    );
                  }))),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }
}
