import 'package:app_wl_cn1/config/colors.dart';
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

class CoinTabBarWidget extends StatefulWidget implements PreferredSizeWidget {
  final List<String> tabs;
  final Color? backgroundColor;
  final TabController? controller;
  final EdgeInsetsGeometry? padding;
  final Function(int)? onTabChange;
  final List<int> dotIndexes;

  const CoinTabBarWidget({
    Key? key,
    required this.tabs,
    this.backgroundColor,
    this.onTabChange,
    this.controller,
    this.padding,
    this.dotIndexes = const [],
  }) : super(key: key);

  @override
  CoinTabBarWidgetState createState() => CoinTabBarWidgetState();

  @override
  Size get preferredSize => const Size.fromHeight(50);
}

class CoinTabBarWidgetState extends State<CoinTabBarWidget> {
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
        color: widget.backgroundColor ?? AppColors.colors[ColorKeys.tabBgColor],
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
            indicator: const UnderlineTabIndicator(
              borderSide: BorderSide(
                width: 3.0,
                color: Color(0xFFb5925c),
              ),
            ),
            tabs: widget.tabs
                .asMap()
                .entries
                .map(
                  (entry) => Tab(
                    height: 25,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(entry.value,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black)),
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
