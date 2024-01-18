import 'package:app_gs/localization/i18n.dart';
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
  final Vod videoDetail;
  VideoActions({super.key, required this.videoDetail});

  final userVodCollectionController = Get.find<UserVodCollectionController>();
  final userFavoritesVideoController = Get.find<UserFavoritesVideoController>();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Obx(() {
            var isLiked = userFavoritesVideoController.videos
                .any((e) => e.id == videoDetail.id);
            return LikeButton(
              text: I18n.pressLikeItIfYouLikeIt,
              isLiked: isLiked,
              onPressed: () {
                if (isLiked) {
                  userFavoritesVideoController.removeVideo([videoDetail.id]);
                } else {
                  userFavoritesVideoController.addVideo(videoDetail);
                }
              },
            );
          }),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Obx(() {
            var isLiked = userVodCollectionController.videos
                .any((e) => e.id == videoDetail.id);
            return LikeButton(
              text: '收藏',
              type: LikeButtonType.bookmark,
              isLiked: isLiked,
              onPressed: () {
                if (isLiked) {
                  userVodCollectionController.removeVideo([videoDetail.id]);
                } else {
                  userVodCollectionController.addVideo(videoDetail);
                }
              },
            );
          }),
        ),
      ],
    );
  }
}
