import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/user_favorites_short_controlle.dart';
import 'package:shared/controllers/user_short_collection_controller.dart';
import 'package:shared/models/vod.dart';
import 'package:shared/widgets/ui_bottom_safearea.dart';

import '../../screens/video/nested_tab_bar_view/enums.dart';
import '../../screens/video/nested_tab_bar_view/like_button.dart';

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
      color: const Color(0xFF030923),
      padding: EdgeInsets.only(top: 18, right: 10, left: 10, bottom: 18),
      child: UIBottomSafeArea(
        child: SizedBox(
          height: 76,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Obx(() {
                  var isLiked = userFavoritesShortController.data
                      .any((e) => e.id == shortData.id);
                  return LikeButton(
                    text: '喜歡就點讚',
                    isLiked: isLiked,
                    onPressed: () {
                      if (isLiked) {
                        userFavoritesShortController
                            .removeVideo([shortData.id]);
                      } else {
                        userFavoritesShortController.addVideo(shortData);
                      }
                    },
                  );
                }),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Obx(() {
                  var isLiked = userShortCollectionController.data
                      .any((e) => e.id == shortData.id);
                  return LikeButton(
                    text: '收藏',
                    type: LikeButtonType.bookmark,
                    isLiked: isLiked,
                    onPressed: () {
                      if (isLiked) {
                        userShortCollectionController
                            .removeVideo([shortData.id]);
                      } else {
                        userShortCollectionController.addVideo(shortData);
                      }
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
