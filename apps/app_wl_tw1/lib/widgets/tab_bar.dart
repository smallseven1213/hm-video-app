import 'package:app_wl_tw1/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/color_keys.dart';

Widget _buildDot() {
  return Padding(
    padding: const EdgeInsets.only(top: 2, left: 1.0),
    child: Container(
      width: 5,
      height: 5,
      decoration: const BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
    ),
  );
}

class TabBarWidget extends StatefulWidget implements PreferredSizeWidget {
  final List<String> tabs;
  final TabController? controller;
  final EdgeInsetsGeometry? padding;
  final Function(int)? onTabChange;
  final List<int> dotIndexes;

  const TabBarWidget({
    Key? key,
    required this.tabs,
    this.onTabChange,
    this.controller,
    this.padding,
    this.dotIndexes = const [],
  }) : super(key: key);

  @override
  TabBarWidgetState createState() => TabBarWidgetState();

  @override
  Size get preferredSize => const Size.fromHeight(50);
}

class TabBarWidgetState extends State<TabBarWidget> {
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
        color: AppColors.colors[ColorKeys.tabBgColor],
        padding: widget.padding ?? const EdgeInsets.symmetric(vertical: 15),
        child: Align(
          child: TabBar(
            isScrollable: true,
            controller: widget.controller,
            labelColor: AppColors.colors[ColorKeys.tabBarTextActiveColor],
            labelStyle: const TextStyle(fontSize: 14),
            labelPadding: const EdgeInsets.symmetric(horizontal: 10),
            unselectedLabelColor: AppColors.colors[ColorKeys.textTertiary],
            indicatorSize: TabBarIndicatorSize.label,
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(
                width: 3.0,
                color: AppColors.colors[ColorKeys.tabBarTextActiveColor]!,
              ),
            ),
            tabs: widget.tabs
                .asMap()
                .entries
                .map(
                  (entry) => Tab(
                    height: 20,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(entry.value),
                        if (widget.dotIndexes.contains(entry.key)) _buildDot()
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ));
  }
}
