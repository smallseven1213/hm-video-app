import 'package:app_51ss/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/color_keys.dart';

class GSTabBar extends StatefulWidget implements PreferredSizeWidget {
  final List<String> tabs;
  final TabController? controller;
  final EdgeInsetsGeometry? padding;
  final Function(int)? onTabChange;

  const GSTabBar({
    Key? key,
    required this.tabs,
    this.onTabChange,
    this.controller,
    this.padding,
  }) : super(key: key);

  @override
  _GSTabBarState createState() => _GSTabBarState();

  @override
  Size get preferredSize => const Size.fromHeight(50);
}

class _GSTabBarState extends State<GSTabBar> {
  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleTabChange);
    if (widget.controller == null) {
      widget.controller?.dispose();
    }
    super.dispose();
  }

  void _handleTabChange() {
    if (widget.controller!.indexIsChanging && widget.onTabChange != null) {
      widget.onTabChange!(widget.controller!.index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        color: AppColors.colors[ColorKeys.background],
        padding: widget.padding ?? const EdgeInsets.symmetric(vertical: 15),
        child: Align(
          child: TabBar(
            isScrollable: true,
            controller: widget.controller,
            padding: const EdgeInsets.all(0),
            labelStyle: const TextStyle(fontSize: 14),
            labelPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            unselectedLabelColor: const Color(0xffb2bac5),
            indicatorSize: TabBarIndicatorSize.label,
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(
                width: 3.0,
                color: AppColors.colors[ColorKeys.primary]!,
              ),
            ),
            tabs: widget.tabs
                .map((text) => Tab(height: 20, child: Text(text)))
                .toList(),
          ),
        ));
  }
}
