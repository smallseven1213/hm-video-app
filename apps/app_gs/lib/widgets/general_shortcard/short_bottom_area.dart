import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/short_video_detail_controller.dart';
import 'package:shared/controllers/user_favorites_short_controlle.dart';
import 'package:shared/controllers/user_short_collection_controller.dart';
import 'package:shared/models/vod.dart';
import 'package:shared/utils/controller_tag_genarator.dart';

import '../../screens/short/button.dart';

final logger = Logger();

class ShortBottomArea extends StatelessWidget {
  final Vod shortData;
  final bool? displayFavoriteAndCollectCount;
  final ShortVideoDetailController? controller;

  const ShortBottomArea({
    Key? key,
    required this.shortData,
    required this.controller,
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
          Obx(() {
            bool isLike = userFavoritesShortController.data
                .any((e) => e.id == shortData.id);
            var favorites = controller!.videoFavorites.value;
            return ShortMenuButton(
              key: Key('short_bottom_area_like_button ${shortData.id}'),
              displayFavoriteAndCollectCount: displayFavoriteAndCollectCount,
              count: favorites,
              subscribe: '喜歡就點讚',
              icon: Icons.favorite_rounded,
              isLike: isLike,
              onTap: () {
                logger
                    .i('===== LIKE ===== $isLike ${shortData.id}} $favorites');
                if (isLike) {
                  userFavoritesShortController.removeVideo([shortData.id]);
                  if (favorites > 0) {
                    controller!.updateFavorites(-1);
                  }
                } else {
                  var vod = Vod.fromJson(shortData.toJson());
                  userFavoritesShortController.addVideo(vod);
                  controller!.updateFavorites(1);
                }
              },
            );
          }),
          Obx(() {
            bool isLike = userShortCollectionController.data
                .any((e) => e.id == shortData.id);
            var collects = controller!.videoCollects.value;
            return ShortMenuButton(
              key: Key('short_bottom_area_collection_button ${shortData.id}'),
              displayFavoriteAndCollectCount: displayFavoriteAndCollectCount,
              count: collects,
              subscribe: '添加到收藏',
              icon: Icons.star_rounded,
              iconSize: 30,
              isLike: isLike,
              onTap: () {
                if (isLike) {
                  userShortCollectionController.removeVideo([shortData.id]);
                  if (collects > 0) {
                    controller!.updateCollects(-1);
                  }
                } else {
                  var vod = Vod.fromJson(shortData.toJson());
                  userShortCollectionController.addVideo(vod);
                  controller!.updateCollects(1);
                }
              },
            );
          }),
        ],
      ),
    );
  }
}
