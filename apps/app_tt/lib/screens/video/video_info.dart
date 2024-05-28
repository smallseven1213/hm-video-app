import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/user_favorites_video_controlle.dart';
import 'package:shared/controllers/user_video_collection_controller.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/models/index.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/utils/video_info_formatter.dart';
import 'package:shared/widgets/video/title.dart';
import 'package:video_player/video_player.dart';

import 'video_collect.dart';
import 'video_favorite.dart';

final logger = Logger();

class Collect extends StatelessWidget {
  final int times;
  final Color? color;
  const Collect({super.key, required this.times, this.color});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      style: const TextStyle(
        height: 1,
      ),
      TextSpan(
        children: [
          WidgetSpan(
            child: Icon(
              Icons.bookmark_border,
              color: color ?? Colors.white,
              size: 16,
            ),
          ),
          TextSpan(
            text: ' ${formatNumberToUnit(times)}',
            style: TextStyle(
              color: color ?? Colors.white,
              letterSpacing: 0.1,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class Favorite extends StatelessWidget {
  final int times;
  final Color? color;
  const Favorite({super.key, required this.times, this.color});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      style: const TextStyle(
        height: 1,
      ),
      TextSpan(
        children: [
          WidgetSpan(
            child: Icon(
              Icons.favorite_border_rounded,
              color: color ?? Colors.white,
              size: 16,
            ),
          ),
          TextSpan(
            text: ' ${formatNumberToUnit(times)}',
            style: TextStyle(
              color: color ?? Colors.white,
              letterSpacing: 0.1,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class ViewTimes extends StatelessWidget {
  final int times;
  final Color? color;
  const ViewTimes({super.key, required this.times, this.color});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      style: const TextStyle(
        height: 1,
      ),
      TextSpan(
        children: [
          WidgetSpan(
            child: Icon(
              Icons.remove_red_eye_outlined,
              color: color ?? Colors.white,
              size: 16,
            ),
          ),
          TextSpan(
            text: ' ${formatNumberToUnit(times)}',
            style: TextStyle(
              color: color ?? Colors.white,
              letterSpacing: 0.1,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class VideoInfo extends StatelessWidget {
  final VideoPlayerController? videoPlayerController;
  final String? externalId;
  final String title;
  final List<Tag> tags;
  final int timeLength;
  final int viewTimes;
  final List<Actor>? actor;
  final Publisher? publisher;
  final int videoFavoriteTimes;
  final Vod videoDetail;

  VideoInfo({
    super.key,
    required this.videoPlayerController,
    required this.title,
    required this.tags,
    required this.timeLength,
    required this.viewTimes,
    required this.videoFavoriteTimes,
    required this.videoDetail,
    this.actor,
    this.externalId,
    this.publisher,
  });

  final userVodCollectionController = Get.find<UserVodCollectionController>();
  final userFavoritesVideoController = Get.find<UserFavoritesVideoController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0, right: 8, left: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VideoTitle(
            externalId: externalId.toString(),
            title: title,
            color: Colors.black,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (publisher != null || (actor != null && actor!.isNotEmpty))
                  Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        if (publisher != null) ...[
                          GestureDetector(
                            onTap: () async {
                              videoPlayerController!.pause();
                              await MyRouteDelegate.of(context).push(
                                AppRoutes.publisher,
                                args: {
                                  'id': publisher!.id,
                                  'title': publisher!.name
                                },
                                removeSamePath: true,
                              );
                              videoPlayerController!.play();
                            },
                            child: Text(
                              publisher!.name,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xffC7C3C3),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          )
                        ],
                      ],
                    ),
                  ),
                // const Spacer(),
                Expanded(
                  flex: 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ViewTimes(
                        times: viewTimes,
                        color: const Color(0xff939393),
                      ),
                      VideoFavorite(videoDetail: videoDetail),
                      VideoCollect(videoDetail: videoDetail),
                    ],
                  ),
                )
              ],
            ),
          ),
          if (tags.isNotEmpty) ...[
            Wrap(
              spacing: 4,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: tags.map((tag) {
                return GestureDetector(
                  onTap: () async {
                    videoPlayerController!.pause();
                    await MyRouteDelegate.of(context).push(AppRoutes.tag,
                        args: {'id': tag.id, 'title': tag.name});
                    videoPlayerController!.play();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: const Color(0xfff6f6f9),
                    ),
                    padding: const EdgeInsets.all(3),
                    child: Text(
                      '#${tag.name}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF161823),
                        letterSpacing: 0.1,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
          ]
        ],
      ),
    );
  }
}
