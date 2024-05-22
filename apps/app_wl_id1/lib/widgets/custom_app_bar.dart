import 'package:app_wl_id1/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/color_keys.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
    this.title = '',
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
                child: const Center(
                  child: Icon(Icons.arrow_back_ios_new, size: 16),
                ),
              ),
            )
          : Container(),
      backgroundColor:
          backgroundColor ?? AppColors.colors[ColorKeys.background],
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
