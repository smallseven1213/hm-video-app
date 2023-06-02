import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/short_video_detail_controller.dart';
import 'package:shared/controllers/user_favorites_short_controlle.dart';
import 'package:shared/controllers/user_short_collection_controller.dart';
import 'package:shared/models/vod.dart';
import 'package:shared/utils/controller_tag_genarator.dart';

import '../screens/short/button.dart';

class ShortBottomArea extends StatelessWidget {
  final Vod shortData;

  const ShortBottomArea({Key? key, required this.shortData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final paddingBottom = MediaQuery.of(context).padding.bottom;
    final ShortVideoDetailController videoDetailController =
        Get.find<ShortVideoDetailController>(
            tag: genaratorShortVideoDetailTag(shortData.id.toString()));
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
            return ShortMenuButton(
              count: videoDetailController.videoDetail.value?.collects ?? 0,
              subscribe: '喜歡就點讚',
              icon: Icons.favorite_rounded,
              isLike: isLike,
              onTap: () {
                if (isLike) {
                  userFavoritesShortController.removeVideo([shortData.id]);
                } else {
                  var vod = Vod.fromJson(shortData.toJson());
                  userFavoritesShortController.addVideo(vod);
                }
              },
            );
          }),
          Obx(() {
            bool isLike = userShortCollectionController.data
                .any((e) => e.id == shortData.id);
            return ShortMenuButton(
              key: ValueKey('collection-${shortData.id}'),
              count: videoDetailController.videoDetail.value?.favorites ?? 0,
              subscribe: '添加到收藏',
              icon: Icons.star_rounded,
              iconSize: 30,
              isLike: isLike,
              onTap: () {
                if (isLike) {
                  userShortCollectionController.removeVideo([shortData.id]);
                } else {
                  var vod = Vod.fromJson(shortData.toJson());
                  userShortCollectionController.addVideo(vod);
                }
              },
            );
          }),
        ],
      ),
    );
  }
}
