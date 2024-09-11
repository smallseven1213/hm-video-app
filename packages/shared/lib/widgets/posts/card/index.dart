import 'package:flutter/material.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/widgets/posts/tags.dart';

import '../../../models/post.dart';
import '../../../navigator/delegate.dart';
import 'media_grid.dart';
import 'post_stats.dart';
import 'supplier_info.dart';

class AppColors {
  static const lightBackground = Colors.white;
  static const darkBackground = Colors.black54;
  static const lightText = Colors.black;
  static const darkText = Colors.white;
  static const lightButton = Colors.pink;
  static const darkButton = Color(0xff6874b6);
  static const lockImage = Color(0xff3f4253);
}

class PostCard extends StatelessWidget {
  final bool? isDarkMode;
  final Post detail;
  final bool? displaySupplierInfo;

  const PostCard({
    Key? key,
    required this.detail,
    this.isDarkMode = true,
    this.displaySupplierInfo = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool darkMode = isDarkMode ?? true;
    final textColor = darkMode ? AppColors.darkText : AppColors.lightText;
    final buttonColor = darkMode ? AppColors.darkButton : AppColors.lightButton;

    return InkWell(
      onTap: () => MyRouteDelegate.of(context).push(
        AppRoutes.post,
        args: {'id': detail.id},
        removeSamePath: true,
      ),
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          border:
              Border(bottom: BorderSide(color: Color(0xff474747), width: 1)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (displaySupplierInfo == true)
                SupplierInfoWidget(
                  supplier: detail.supplier!,
                  darkMode: darkMode,
                  textColor: textColor,
                  buttonColor: buttonColor,
                ),
              const SizedBox(height: 8),
              PostTitleWidget(title: detail.title, textColor: textColor),
              TagsWidget(tags: detail.tags),
              const SizedBox(height: 8),
              MediaGridWidget(
                files: detail.files,
                totalMediaCount: detail.totalMediaCount,
                previewMediaCount: detail.previewMediaCount,
                isUnlock: detail.isUnlock,
                darkMode: darkMode,
              ),
              PostStatsWidget(
                viewCount: detail.viewCount ?? 0,
                likeCount: detail.likeCount ?? 0,
                commentCount: 2,
                postId: detail.id,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PostTitleWidget extends StatelessWidget {
  final String title;
  final Color textColor;

  const PostTitleWidget({
    Key? key,
    required this.title,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(color: textColor),
    );
  }
}
