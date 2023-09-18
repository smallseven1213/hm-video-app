import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:app_sv/config/colors.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/models/vod.dart';
import 'package:shared/controllers/user_favorites_video_controlle.dart';

class VideoFavorite extends StatefulWidget {
  final Vod videoDetail;
  const VideoFavorite({super.key, required this.videoDetail});

  @override
  State<VideoFavorite> createState() => _VideoFavoriteState();
}

class _VideoFavoriteState extends State<VideoFavorite> {
  final userFavoritesVideoController = Get.find<UserFavoritesVideoController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var isLiked = userFavoritesVideoController.videos
          .any((e) => e.id == widget.videoDetail.id);
      return InkWell(
        onTap: () {
          if (isLiked) {
            userFavoritesVideoController.removeVideo([widget.videoDetail.id]);
          } else {
            userFavoritesVideoController.addVideo(widget.videoDetail);
          }
        },
        child: Text.rich(
          style: const TextStyle(
            height: 1,
          ),
          TextSpan(
            children: [
              WidgetSpan(
                child: Align(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.favorite_sharp,
                    color: isLiked
                        ? Colors.red
                        : AppColors.colors[ColorKeys.textVideoInfoDetail],
                    size: 16,
                  ),
                ),
              ),
              const WidgetSpan(
                child: SizedBox(width: 3), // 添加間距
              ),
              WidgetSpan(
                child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      isLiked
                          ? (widget.videoDetail.videoFavoriteTimes! + 1)
                              .toString()
                          : widget.videoDetail.videoFavoriteTimes.toString(),
                      style: TextStyle(
                        color: AppColors.colors[ColorKeys.textVideoInfoDetail],
                        letterSpacing: 0.1,
                        fontSize: 12,
                      ),
                    )),
              ),
            ],
          ),
        ),
      );
    });
  }
}
