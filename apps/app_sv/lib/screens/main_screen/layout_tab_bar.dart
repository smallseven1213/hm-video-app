import 'package:app_sv/config/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/widgets/layout_tab_builder.dart';
import 'package:shared/widgets/layout_tab_item_builder.dart';

var logger = Logger();

class LayoutTabBar extends StatelessWidget {
  final int layoutId;
  const LayoutTabBar({
    Key? key,
    required this.layoutId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutTabBuilder(
        layoutId: layoutId,
        barItemWidget: ({
          required int layoutId,
          required int index,
          required String name,
        }) =>
            LayoutTabBarItemBuilder(
                layoutId: layoutId,
                index: index,
                name: name,
                itemWidget: ({required bool isActive}) => Container(
                      color: Colors.transparent,
                      child: Text(
                        name,
                        style: TextStyle(
                          color: isActive
                              ? AppColors.colors[ColorKeys.tabTextActiveColor]
                              : AppColors.colors[ColorKeys.tabTextColor],
                        ),
                      ),
                    )),
        tabbarWidget: ({
          required TabController tabController,
          required List<Widget> tabItems,
          required Function(int) onTapTabItem,
        }) =>
            SizedBox(
              width: double.infinity,
              child: TabBar(
                  physics: kIsWeb ? null : const BouncingScrollPhysics(),
                  isScrollable: true,
                  controller: tabController,
                  labelStyle: const TextStyle(
                    fontSize: 14,
                    letterSpacing: 0.05,
                  ),
                  unselectedLabelColor: const Color(0xffb2bac5),
                  indicator: UnderlineTabIndicator(
                    borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(3), right: Radius.circular(3)),
                    borderSide: BorderSide(
                      width: 3.0,
                      color: AppColors.colors[ColorKeys.tabTextActiveColor]
                          as Color,
                    ),
                    insets: const EdgeInsets.only(
                      left: 18,
                      right: 18,
                      bottom: 4,
                    ),
                  ),
                  onTap: onTapTabItem,
                  tabs: tabItems),
            ));
  }
}
