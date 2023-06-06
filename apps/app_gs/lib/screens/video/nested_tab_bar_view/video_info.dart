// VideoScreen stateless
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/models/index.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/widgets/video_time.dart';
import 'package:shared/widgets/view_times.dart';

final logger = Logger();

class VideoInfo extends StatelessWidget {
  final String title;
  final List<Tag> tags;
  final int timeLength;
  final int viewTimes;
  final List<Actor>? actor;
  final Publisher? publisher;
  final Function() playVideo;
  final Function() pauseVideo;

  const VideoInfo({
    super.key,
    required this.title,
    required this.tags,
    required this.timeLength,
    required this.viewTimes,
    required this.playVideo,
    required this.pauseVideo,
    this.actor,
    this.publisher,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        // 供應商、演員、觀看次數、時長
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
                        InkWell(
                          onTap: () async {
                            pauseVideo();
                            await MyRouteDelegate.of(context).push(
                              AppRoutes.publisher.value,
                              args: {
                                'id': publisher!.id,
                                'title': publisher!.name
                              },
                              removeSamePath: true,
                            );
                            playVideo();
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
                      if (actor != null && actor!.isNotEmpty)
                        InkWell(
                          onTap: () async {
                            pauseVideo();
                            await MyRouteDelegate.of(context).push(
                              AppRoutes.actor.value,
                              args: {
                                'id': actor![0].id,
                                'title': actor![0].name
                              },
                              removeSamePath: true,
                            );
                            playVideo();
                          },
                          child: Text(
                            actor![0].name,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xffC7C3C3),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              // const Spacer(),
              Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ViewTimes(
                        times: viewTimes,
                        color: const Color(0xffC7C3C3),
                      ),
                      VideoTime(
                        time: timeLength,
                        color: const Color(0xffC7C3C3),
                        hasIcon: true,
                      ),
                    ],
                  ))
            ],
          ),
        ),
        if (tags.isNotEmpty) ...[
          Wrap(
            spacing: 4,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: tags.map((tag) {
              return InkWell(
                onTap: () async {
                  pauseVideo();
                  await MyRouteDelegate.of(context).push(AppRoutes.tag.value,
                      args: {'id': tag.id, 'title': tag.name});
                  playVideo();
                },
                child: Text(
                  '#${tag.name}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF00B2FF),
                    letterSpacing: 0.1,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
        ]
      ],
    );
  }
}
