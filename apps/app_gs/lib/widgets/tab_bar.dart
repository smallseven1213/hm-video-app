import 'package:app_gs/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/color_keys.dart';

class GSTabBar extends StatelessWidget implements PreferredSizeWidget {
  final List<String> tabs;
  final TabController? controller;
  final EdgeInsetsGeometry? padding;

  const GSTabBar({
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
      color: AppColors.colors[ColorKeys.background],
      padding: padding ?? const EdgeInsets.only(bottom: 8),
      child: Align(
        child: SizedBox(
          width: tabs.length * 100,
          child: TabBar(
            controller: controller,
            indicatorPadding: const EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 8,
            ),
            labelStyle: const TextStyle(
              fontSize: 14,
            ),
            labelPadding: const EdgeInsets.only(
              left: 0,
              right: 0,
              bottom: 0,
            ),
            unselectedLabelColor: const Color(0xffb2bac5),
            indicator: UnderlineTabIndicator(
              borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(3), right: Radius.circular(3)),
              borderSide: BorderSide(
                width: 3.0,
                color: AppColors.colors[ColorKeys.primary]!,
              ),
              insets: const EdgeInsets.only(
                left: 10,
                right: 10,
                bottom: 3,
              ),
            ),
            tabs: tabs.map((text) => Tab(text: text)).toList(),
          ),
        ),
      ),
    );
  }
}
