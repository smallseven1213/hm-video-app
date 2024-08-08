import 'package:flutter/material.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/enums/file_type.dart';
import 'package:shared/widgets/posts/post_stats.dart';
import 'package:shared/widgets/posts/tags.dart';
import 'package:shared/widgets/sid_image.dart';

import '../../models/post.dart';
import '../../navigator/delegate.dart';

// 定義顏色配置
class AppColors {
  static const lightBackground = Colors.white;
  static const darkBackground = Colors.black54;
  static const lightText = Colors.black;
  static const darkText = Colors.white;
  static const lightButton = Colors.pink;
  static const darkButton = Color(0xff6874b6);
  static const lockImage = Color(0xff3f4253);
}

class PostHorizontalCard extends StatelessWidget {
  final bool? isDarkMode;
  final Post detail;

  const PostHorizontalCard({
    Key? key,
    required this.detail,
    this.isDarkMode = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool darkMode = isDarkMode ?? true;
    final textColor = darkMode ? AppColors.darkText : AppColors.lightText;

    return InkWell(
      onTap: () {
        MyRouteDelegate.of(context).push(
          AppRoutes.post,
          args: {'id': detail.id},
          removeSamePath: true,
        );
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
              child: Container(
                width: 150,
                height: 93,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.withOpacity(0.4), // 預設顏色，當沒有圖片時顯示
                ),
                child: detail.files.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Stack(
                          children: [
                            SidImage(sid: detail.files[0].cover),
                            if (detail.files[0].type == FileType.video.index)
                              Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Icon(
                                    Icons.play_arrow_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            if (!detail.isUnlock &&
                                0 >= detail.previewMediaCount)
                              Container(
                                color: Colors.black.withOpacity(0.5),
                                child: const Center(
                                  child: Icon(
                                    Icons.lock,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      )
                    : const Center(
                        child: Icon(
                          Icons.image,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    detail.title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: textColor),
                  ),
                  PostStatsWidget(
                    viewCount: detail.viewCount ?? 0,
                    likeCount: detail.likeCount ?? 0,
                  ),
                  TagsWidget(tags: detail.tags),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
