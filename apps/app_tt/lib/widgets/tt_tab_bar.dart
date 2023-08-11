import 'package:flutter/material.dart';

class TTTabBar extends StatelessWidget implements PreferredSizeWidget {
  final List<String> tabs;
  final TabController? controller;
  final EdgeInsetsGeometry? padding;

  const TTTabBar({
    super.key,
    required this.tabs,
    this.controller,
    this.padding,
  });

  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        color: Colors.white,
        padding: padding ?? const EdgeInsets.symmetric(vertical: 15),
        child: Align(
          child: TabBar(
            isScrollable: true,
            controller: controller,
            padding: const EdgeInsets.all(0),
            labelStyle: const TextStyle(fontSize: 14),
            labelPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            unselectedLabelColor: const Color(0xff73747b),
            indicatorSize: TabBarIndicatorSize.label,
            indicator: const UnderlineTabIndicator(
              borderSide: BorderSide(
                width: 3.0,
                color: Colors.black,
              ),
            ),
            tabs:
                tabs.map((text) => Tab(height: 20, child: Text(text))).toList(),
          ),
        ));
  }
}
