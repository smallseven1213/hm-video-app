// CustomAppBar return
import 'package:app_gp/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/color_keys.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
    required this.title,
    this.actions, // 新增actions參數
  }) : super(key: key);

  final String title;
  final List<Widget>? actions; // 定義actions列表

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.colors[ColorKeys.background],
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
        ),
      ),
      actions: actions, // 將actions添加到AppBar
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
