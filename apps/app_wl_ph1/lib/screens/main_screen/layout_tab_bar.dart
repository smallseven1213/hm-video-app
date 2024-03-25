import 'package:app_wl_ph1/config/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/widgets/layout_tab_builder.dart';
import 'package:shared/widgets/layout_tab_item_builder.dart';

var logger = Logger();

// class LayoutTabBar extends StatefulWidget {
//   final int layoutId;
//   const LayoutTabBar({
//     Key? key,
//     required this.layoutId,
//   }) : super(key: key);

//   @override
//   LayoutTabBarState createState() => LayoutTabBarState();
// }

// class LayoutTabBarState extends State<LayoutTabBar>
//     with TickerProviderStateMixin {
//   late ChannelScreenTabController channelScreenTabController;
//   late LayoutController layoutController;
//   late Worker layoutWorker;
//   late Worker screenTabWorker;

//   late TabController tabController;
//   List<LayoutTabBarItem> tabItems = <LayoutTabBarItem>[];

//   @override
//   void initState() {
//     super.initState();
//     channelScreenTabController = Get.find<ChannelScreenTabController>(
//         tag: 'channel-screen-${widget.layoutId}');

//     layoutController =
//         Get.find<LayoutController>(tag: 'layout${widget.layoutId}');
//     _updateTabItems();
//     _initializeTabController();

//     layoutWorker = ever(layoutController.layout, (channels) {
//       setState(() {
//         _updateTabItems();
//         _initializeTabController();
//       });
//     });

//     screenTabWorker = ever(channelScreenTabController.tabIndex, (callback) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         if (tabController.index != callback && tabItems.isNotEmpty && mounted) {
//           tabController.animateTo(callback);
//         }
//       });
//     });
//   }

//   void _updateTabItems() {
//     tabItems = layoutController.layout
//         .map((e) => LayoutTabBarItem(
//               layoutId: widget.layoutId,
//               index: layoutController.layout.indexOf(e),
//               name: e.name,
//             ))
//         .toList();
//   }

//   void _initializeTabController() {
//     tabController = TabController(
//       length: tabItems.length,
//       vsync: this,
//     );
//   }

//   @override
//   void dispose() {
//     tabController.dispose();
//     layoutWorker.dispose();
//     screenTabWorker.dispose();
//     super.dispose();
//   }

//   void handleTapTabItem(int index) {
//     channelScreenTabController.pageViewIndex.value = index;
//   }

//   @override
//   Widget build(BuildContext context) {
//     logger.i('RENDER LayoutTabBarState');
//     if (tabItems.isEmpty) {
//       return Container();
//     }
//     return Container(
//       height: 65,
//       width: double.infinity,
//       padding: const EdgeInsets.only(top: 8),
//       child: TabBar(
//           tabAlignment: TabAlignment.center,
//           physics: kIsWeb ? null : const BouncingScrollPhysics(),
//           isScrollable: true,
//           controller: tabController,
//           labelStyle: TextStyle(
//             fontSize: 14,
//             letterSpacing: 0.05,
//             color: AppColors.colors[ColorKeys.primary],
//           ),
//           unselectedLabelColor: const Color(0xffb2bac5),
//           indicator: UnderlineTabIndicator(
//             borderRadius: const BorderRadius.horizontal(
//                 left: Radius.circular(3), right: Radius.circular(3)),
//             borderSide: BorderSide(
//               width: 3.0,
//               color: AppColors.colors[ColorKeys.primary]!,
//             ),
//             insets: const EdgeInsets.only(
//               left: 18,
//               right: 18,
//               bottom: 4,
//             ),
//           ),
//           onTap: handleTapTabItem,
//           tabs: tabItems),
//     );
//   }
// }

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
