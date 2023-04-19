import 'package:app_gs/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/color_keys.dart';

class GSTabBar extends StatelessWidget implements PreferredSizeWidget {
  final List<String> tabs;
  final TabController? controller;

  const GSTabBar({
    super.key,
    required this.tabs,
    this.controller,
  });

  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.colors[ColorKeys.background],
      padding: const EdgeInsets.only(bottom: 8),
      child: Align(
        child: SizedBox(
          width: tabs.length * 100,
          child: TabBar(
            controller: controller,
            indicatorPadding: const EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 4,
            ),
            indicatorWeight: 5,
            indicatorColor: AppColors.colors[ColorKeys.primary],
            indicator: UnderlineTabIndicator(
              borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(10), right: Radius.circular(10)),
              borderSide: BorderSide(
                width: 5.0,
                color: AppColors.colors[ColorKeys.primary]!,
              ),
              insets: const EdgeInsets.only(
                left: 10,
                right: 10,
                bottom: 0,
              ),
            ),
            tabs: tabs.map((text) => Tab(text: text)).toList(),
          ),
        ),
      ),
    );
  }
}
