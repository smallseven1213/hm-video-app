import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:app_wl_cn1/config/colors.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/models/vod.dart';
import 'package:shared/controllers/user_video_collection_controller.dart';

class VideoCollect extends StatefulWidget {
  final Vod videoDetail;
  const VideoCollect({super.key, required this.videoDetail});

  @override
  State<VideoCollect> createState() => _VideoCollectState();
}

class _VideoCollectState extends State<VideoCollect> {
  final userVodCollectionController = Get.find<UserVodCollectionController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var isCollected = userVodCollectionController.videos
          .any((e) => e.id == widget.videoDetail.id);
      return InkWell(
        onTap: () {
          if (isCollected) {
            userVodCollectionController.removeVideo([widget.videoDetail.id]);
          } else {
            userVodCollectionController.addVideo(widget.videoDetail);
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
                    Icons.bookmark_rounded,
                    color: isCollected
                        ? Colors.yellow.shade700
                        : AppColors.colors[ColorKeys.textVideoInfoDetail],
                    size: 16,
                  ),
                ),
              ),
              const WidgetSpan(
                child: SizedBox(width: 3), // 添加间距
              ),
              WidgetSpan(
                child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      isCollected
                          ? (widget.videoDetail.videoCollectTimes! + 1)
                              .toString()
                          : widget.videoDetail.videoCollectTimes.toString(),
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
