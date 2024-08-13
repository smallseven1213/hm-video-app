import 'package:flutter/material.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/models/post_detail.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/widgets/posts/post_stats.dart';
import 'package:shared/widgets/posts/tags.dart';

import 'package:shared/widgets/sid_image.dart';

class RecommendWidget extends StatelessWidget {
  final List<Recommend> recommendations;

  RecommendWidget({required this.recommendations});

  @override
  Widget build(BuildContext context) {
    if (recommendations.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 其他推薦貼文
          Row(
            children: [
              Container(
                width: 3,
                height: 8,
                decoration: BoxDecoration(
                  color: const Color(0xfff4cdca),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 4),
              const Text(
                '其他推薦貼文',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...recommendations.asMap().entries.map((entry) {
                  final int index = entry.key;
                  final Recommend recommendation = entry.value;
                  return InkWell(
                    onTap: () {
                      MyRouteDelegate.of(context).push(
                        AppRoutes.post,
                        args: {'id': recommendation.id},
                        removeSamePath: true,
                      );
                    },
                    child: Container(
                        height: 100,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 4),
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            SizedBox(height: 4),
                            // 圖片
                            SizedBox(
                              width: 164,
                              height: 100,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: SidImage(sid: recommendation.cover),
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // 標題
                                  Text(
                                    recommendation.title,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white),
                                    maxLines: 2,
                                  ),
                                  // 觀看和點讚數
                                  PostStatsWidget(
                                    viewCount: recommendation.viewCount,
                                    likeCount: recommendation.likeCount,
                                  ),
                                  // 標籤

                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child:
                                          TagsWidget(tags: recommendation.tags),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )),
                  );
                }).toList()
              ],
            ),
          ),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
