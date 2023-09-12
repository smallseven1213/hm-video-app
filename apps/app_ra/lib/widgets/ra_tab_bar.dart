import 'package:app_ra/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/color_keys.dart';

class RATabBar extends StatelessWidget implements PreferredSizeWidget {
  final List<String> tabs;
  final TabController? controller;
  final EdgeInsetsGeometry? padding;

  const RATabBar({
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
        color: AppColors.colors[ColorKeys.background],
        padding: padding ?? const EdgeInsets.symmetric(vertical: 15),
        child: Align(
          child: TabBar(
            isScrollable: true,
            controller: controller,
            padding: const EdgeInsets.all(0),
            labelStyle: const TextStyle(fontSize: 15, color: Colors.black),
            labelPadding:
                const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
            indicator: BoxDecoration(
              border: Border.all(
                color: AppColors.colors[ColorKeys.textPrimary]!,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(15.0),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: tabs
                .map(
                  (text) => Tab(
                    height: 24,
                    child: Text(
                      text,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                )
                .toList(),
          ),
        ));
  }
}
