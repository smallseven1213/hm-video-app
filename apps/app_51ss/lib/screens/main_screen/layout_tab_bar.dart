import 'package:app_51ss/config/colors.dart';
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
                              ? AppColors.colors[ColorKeys.primary]
                              : const Color(0xffCFCECE),
                        ),
                      ),
                    )),
        tabbarWidget: ({
          required TabController tabController,
          required List<Widget> tabItems,
          required Function(int) onTapTabItem,
        }) =>
            Container(
              height: 65,
              width: double.infinity,
              padding: const EdgeInsets.only(top: 8),
              child: TabBar(
                  // tabAlignment: TabAlignment.center,
                  physics: kIsWeb ? null : const BouncingScrollPhysics(),
                  isScrollable: true,
                  controller: tabController,
                  labelStyle: TextStyle(
                    fontSize: 14,
                    letterSpacing: 0.05,
                    color: AppColors.colors[ColorKeys.primary],
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
