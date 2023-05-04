// VideoScreen stateless
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/user_favorites_video_controlle.dart';
import 'package:shared/controllers/user_video_collection_controller.dart';
import 'package:shared/models/index.dart';

import 'enums.dart';
import 'like_button.dart';

final logger = Logger();

class VideoActions extends StatelessWidget {
  final Video videoBase;
  final Vod videoDetail;
  VideoActions({super.key, required this.videoBase, required this.videoDetail});

  final userCollectionController = Get.find<UserCollectionController>();
  final userFavoritesVideoController = Get.find<UserFavoritesVideoController>();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Obx(() {
            var isLiked = userFavoritesVideoController.videos
                .any((e) => e.id == videoBase.id);
            return LikeButton(
              text: '喜歡就點讚',
              isLiked: isLiked,
              onPressed: () {
                if (isLiked) {
                  userFavoritesVideoController.removeVideo([videoBase.id]);
                } else {
                  // 將videoBase的值寫入到Vod class
                  var vod = Vod.fromJson(videoBase.toJson());
                  userFavoritesVideoController.addVideo(vod);
                }
              },
            );
          }),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Obx(() {
            var isLiked = userCollectionController.videos
                .any((e) => e.id == videoBase.id);
            return LikeButton(
              text: '收藏',
              type: LikeButtonType.bookmark,
              isLiked: isLiked,
              onPressed: () {
                if (isLiked) {
                  userCollectionController.removeVideo([videoDetail.id]);
                } else {
                  var vod = Vod.fromJson(videoBase.toJson());
                  userCollectionController.addVideo(vod);
                }
              },
            );
          }),
        ),
      ],
    );
  }
}
