import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/widgets/layout_tab_builder.dart';
import 'package:shared/widgets/layout_tab_item_builder.dart';

import '../../controllers/tt_ui_controller.dart';

class LayoutTabBar extends StatelessWidget {
  final int layoutId;
  const LayoutTabBar({
    Key? key,
    required this.layoutId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TTUIController ttUiController = Get.find<TTUIController>();

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
                  child: Obx(() {
                    final isDarkMode = ttUiController.isDarkMode.value;
                    final fontColor = isDarkMode
                        ? isActive
                            ? Colors.white
                            : const Color(0xFF676970)
                        : isActive
                            ? Colors.black
                            : const Color(0xFF999999);
                    return Text(
                      name,
                      style: TextStyle(
                        color: fontColor,
                      ),
                    );
                  }))),
      tabbarWidget: ({
        required TabController tabController,
        required List<Widget> tabItems,
        required Function(int) onTapTabItem,
      }) =>
          Container(
              height: 65,
              width: double.infinity,
              padding: const EdgeInsets.only(top: 8),
              child: Obx(
                () {
                  final isDarkMode = ttUiController.isDarkMode.value;
                  return TabBar(
                      tabAlignment: TabAlignment.center,
                      physics: kIsWeb ? null : const BouncingScrollPhysics(),
                      isScrollable: true,
                      controller: tabController,
                      labelStyle: TextStyle(
                        fontSize: 14,
                        letterSpacing: 0.05,
                        color:
                            isDarkMode ? Colors.white : const Color(0xFF161823),
                      ),
                      unselectedLabelColor: const Color(0xffb2bac5),
                      indicator: UnderlineTabIndicator(
                        borderRadius: const BorderRadius.horizontal(
                            left: Radius.circular(3),
                            right: Radius.circular(3)),
                        borderSide: BorderSide(
                          width: 3.0,
                          color: isDarkMode
                              ? Colors.white
                              : const Color(0xFF161823),
                        ),
                        insets: const EdgeInsets.only(
                            left: 18, right: 18, bottom: 4),
                      ),
                      onTap: onTapTabItem,
                      tabs: tabItems);
                },
              )),
    );
  }
}
