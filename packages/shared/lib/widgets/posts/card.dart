import 'package:flutter/material.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/widgets/avatar.dart';
import 'package:shared/widgets/posts/follow_button.dart';

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
  static const darkButton = Colors.deepOrange;
}

class PostCard extends StatelessWidget {
  final String upName;
  final String postContent;
  final int postId;
  final Supplier supplier;
  final bool? isDarkMode;

  const PostCard({
    Key? key,
    required this.postId,
    required this.upName,
    required this.postContent,
    required this.supplier,
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
          args: {'id': postId},
          removeSamePath: true,
        );
      },
      child: Container(
        color: backgroundColor,
        margin: const EdgeInsets.all(8),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AvatarWidget(photoSid: supplier.coverVertical),
                  SizedBox(width: 8),
                  Text(
                    supplier.name ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  Spacer(),
                  FollowButton(
                    supplier: supplier,
                    isDarkMode: darkMode,
                    backgroundColor: buttonColor,
                    textColor: textColor,
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                postContent,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: textColor),
              ),
              SizedBox(height: 8),
              GridView.count(
                shrinkWrap: true, // 使 GridView 自適應高度
                physics: NeverScrollableScrollPhysics(), // 禁止滾動
                crossAxisCount: 3, // 每行三個元素
                mainAxisSpacing: 5, // 主軸間距
                crossAxisSpacing: 5, // 交叉軸間距
                children: List.generate(6, (index) {
                  return Container(
                    color: Colors.blue, // 正方形的顏色，可以根據需要更改
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
