import 'package:app_gp/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/color_keys.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
    required this.title,
    this.backgroundColor,
    this.bottom,
    this.actions, // 新增actions參數
  }) : super(key: key);

  final String title;
  final Color? backgroundColor;
  final List<Widget>? actions; // 定義actions列表
  final PreferredSizeWidget? bottom;

  @override
  Size get preferredSize {
    final double bottomHeight = bottom?.preferredSize.height ?? 0;
    return Size.fromHeight(kToolbarHeight + bottomHeight);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, size: 16),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      backgroundColor:
          backgroundColor ?? AppColors.colors[ColorKeys.background],
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
        ),
      ),
      bottom: bottom,
      actions: actions, // 將actions添加到AppBar
    );
  }
}
