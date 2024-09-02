import 'package:flutter/material.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/enums/file_type.dart';
import 'package:shared/widgets/avatar.dart';
import 'package:shared/widgets/posts/follow_button.dart';
import 'package:shared/widgets/posts/post_stats.dart';
import 'package:shared/widgets/posts/tags.dart';
import 'package:shared/widgets/sid_image.dart';

import '../../models/post.dart';
import '../../models/supplier.dart';
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
    // 使用 ?? 運算符提供默認值
    final bool darkMode = isDarkMode ?? true;

    // 根據 darkMode 設置顏色
    final textColor = darkMode ? AppColors.darkText : AppColors.lightText;
    final buttonColor = darkMode ? AppColors.darkButton : AppColors.lightButton;
    final lockImageColor = darkMode ? AppColors.lockImage : Colors.white;

    return InkWell(
      onTap: () {
        // 點擊卡片時的操作
        MyRouteDelegate.of(context).push(
          AppRoutes.post,
          args: {'id': detail.id},
          removeSamePath: true,
        );
      },
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
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        MyRouteDelegate.of(context).push(
                          AppRoutes.supplier,
                          args: {'id': detail.supplier!.id},
                          removeSamePath: true,
                        );
                      },
                      child: Row(
                        children: [
                          AvatarWidget(
                              photoSid: detail.supplier!.photoSid,
                              backgroundColor: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            detail.supplier!.aliasName ?? '',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    FollowButton(
                      supplier: detail.supplier ?? Supplier(),
                      isDarkMode: darkMode,
                      backgroundColor: buttonColor,
                      textColor: textColor,
                    ),
                  ],
                ),
              const SizedBox(height: 8),
              Text(
                detail.title,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: textColor),
              ),
              PostStatsWidget(
                viewCount: detail.viewCount ?? 0,
                likeCount: detail.likeCount ?? 0,
                postId: detail.id,
              ),
              Wrap(
                spacing: 8, // 交叉軸間距
                runSpacing: 8, // 主軸間距
                children: List.generate(
                  // 計算要顯示的元素數量，最多6個
                  detail.totalMediaCount <= 6 ? detail.totalMediaCount : 6,
                  (index) {
                    bool shouldShowLock =
                        !detail.isUnlock && index >= detail.previewMediaCount;

                    if (detail.files.length > index) {
                      return SizedBox(
                        width: (MediaQuery.of(context).size.width - 32) / 3,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Stack(
                              children: [
                                SidImage(sid: detail.files[index].cover),
                                if (detail.files[index].type ==
                                    FileType.video.index)
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
                                if (shouldShowLock)
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
                          ),
                        ),
                      );
                    } else {
                      return Container(
                        width: (MediaQuery.of(context).size.width - 32) / 3,
                        height: (MediaQuery.of(context).size.width - 32) / 3,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: shouldShowLock
                            ? Container(
                                decoration: BoxDecoration(
                                  color: lockImageColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Container(
                                    width: 25,
                                    height: 25,
                                    decoration: BoxDecoration(
                                      color:
                                          const Color.fromRGBO(44, 49, 70, 0.7),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Icon(
                                      Icons.lock,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                  ),
                                ),
                              )
                            : const Icon(
                                Icons.image,
                                color: Colors.white,
                              ),
                      );
                    }
                  },
                ),
              ),
              // create tag list
              TagsWidget(tags: detail.tags),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
