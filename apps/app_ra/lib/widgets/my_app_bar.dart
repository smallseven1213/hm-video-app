import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({
    Key? key,
    this.title,
    this.titleWidget,
    this.backgroundColor,
    this.bottom,
    this.actions,
  }) : super(key: key);

  final String? title;
  final Widget? titleWidget;
  final Color? backgroundColor;
  final List<Widget>? actions;
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
                color: Color(0xFF030923),
                child: const Center(
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    size: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            )
          : Container(),
      backgroundColor: backgroundColor ?? Color(0xFF030923),
      title: titleWidget ??
          Text(
            title!,
            style: const TextStyle(fontSize: 15, color: Color(0xFFFDDCEF)),
          ),
      bottom: bottom,
      actions: actions, // 將actions添加到AppBar
    );
  }
}
