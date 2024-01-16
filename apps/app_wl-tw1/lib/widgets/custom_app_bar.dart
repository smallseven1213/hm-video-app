import 'package:flutter/material.dart';
import 'package:shared/models/color_keys.dart';

import '../config/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
    this.title,
    this.titleWidget,
    this.backgroundColor,
    this.bottom,
    this.actions, // 新增actions參數
  }) : super(key: key);

  final String? title;
  final Widget? titleWidget;
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
      elevation: 0,
      centerTitle: true,
      leading: Navigator.canPop(context)
          ? GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                height: 56.0,
                width: 56.0,
                color: Colors.transparent,
                child: Center(
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    size: 16,
                    color: AppColors.colors[ColorKeys.buttonTextPrimary],
                  ),
                ),
              ),
            )
          : Container(),
      backgroundColor: backgroundColor ?? AppColors.colors[ColorKeys.primary],
      title: titleWidget ??
          Text(
            title!,
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
      bottom: bottom,
      actions: actions, // 將actions添加到AppBar
    );
  }
}
