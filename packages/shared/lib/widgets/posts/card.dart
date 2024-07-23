import 'package:flutter/material.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/widgets/avatar.dart';
import 'package:shared/widgets/posts/follow_button.dart';
import 'package:shared/widgets/sid_image.dart';

import '../../models/post.dart';
import '../../models/supplier.dart';
import '../../modules/user/user_favorites_supplier_consumer.dart';
import '../../navigator/delegate.dart';

// 定義顏色配置
class AppColors {
  static const lightBackground = Colors.white;
  static const darkBackground = Colors.black54;
  static const lightText = Colors.black;
  static const darkText = Colors.white;
  static const lightButton = Colors.pink;
  static const darkButton = Color(0xff6874b6);
}

class PostCard extends StatelessWidget {
  final bool? isDarkMode;
  final Post detail;
  const PostCard({
    Key? key,
    required this.detail,
    this.isDarkMode = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 使用 ?? 運算符提供默認值
    final bool darkMode = isDarkMode ?? true;

    // 根據 darkMode 設置顏色
    final backgroundColor =
        darkMode ? AppColors.darkBackground : AppColors.lightBackground;
    final textColor = darkMode ? AppColors.darkText : AppColors.lightText;
    final buttonColor = darkMode ? AppColors.darkButton : AppColors.lightButton;
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
        color: backgroundColor,
        margin: const EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
              const SizedBox(height: 8),
              GridView.count(
                shrinkWrap: true, // 使 GridView 自適應高度
                physics: const NeverScrollableScrollPhysics(), // 禁止滾動
                crossAxisCount: 3, // 每行三個元素
                mainAxisSpacing: 8, // 主軸間距
                crossAxisSpacing: 8, // 交叉軸間距
                children: List.generate(
                    // 計算要顯示的元素數量，最多6個
                    detail.previewMediaCount < detail.totalMediaCount
                        ? (detail.previewMediaCount + 1 <= 6
                            ? detail.previewMediaCount + 1
                            : 6)
                        : (detail.previewMediaCount <= 6
                            ? detail.previewMediaCount
                            : 6), (index) {
                  if (index < detail.previewMediaCount) {
                    return detail.files.length > index
                        ? SidImage(sid: detail.files[index].path)
                        : Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.4), // 設置空圖片的背景色
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.image, // 使用一個圖片icon表示空圖片
                              color: Colors.grey[400],
                            ),
                          );
                  } else {
                    // 顯示帶鎖頭 icon 的方框
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.lock, color: Colors.grey[600]),
                    );
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
