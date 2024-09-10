import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared/controllers/bottom_navigator_controller.dart';
import 'package:shared/controllers/ui_controller.dart';
import 'package:shared/enums/home_navigator_pathes.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/modules/main_layout/display_layout_tab_search_consumer.dart';
import 'package:shared/modules/main_layout/main_layout_loading_status_consumer.dart';
import 'package:shared/modules/main_layout/layout_style_tab_bg_consumer.dart';

import 'package:app_sv/config/colors.dart';
import 'package:app_sv/screens/main_screen/channels.dart';
import 'package:app_sv/widgets/flash_loading.dart';

import 'channel_search_bar.dart';
import 'floating_button.dart';
import 'layout_tab_bar.dart';

class HomeMainScreen extends StatefulWidget {
  final int layoutId;
  const HomeMainScreen({Key? key, required this.layoutId}) : super(key: key);

  @override
  State<HomeMainScreen> createState() => HomeMainScreenState();
}

class HomeMainScreenState extends State<HomeMainScreen> {
  final uiController = Get.find<UIController>();
  late BottomNavigatorController bottomNavigatorController;
  bool displayFab = true;

  @override
  void initState() {
    super.initState();
    bottomNavigatorController = Get.find<BottomNavigatorController>();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        child: MainLayoutLoadingStatusConsumer(
          layoutId: widget.layoutId,
          child: (isLoading) {
            if (isLoading) {
              return const Scaffold(
                body: Center(child: FlashLoading()),
              );
            }
            return Scaffold(
                body: Stack(
              children: [
                Channels(
                  key: Key('channels-${widget.layoutId}'),
                  layoutId: widget.layoutId,
                ),
                Positioned(
                    child: Column(
                  children: [
                    LayoutStyleTabBgColorConsumer(
                      layoutId: widget.layoutId,
                      child: (({required bool needTabBgColor}) => Container(
                            color: needTabBgColor
                                ? AppColors.colors[ColorKeys.primary]
                                : Colors.transparent,
                            height: MediaQuery.paddingOf(context).top,
                          )),
                    ),
                    DisplayLayoutTabSearchConsumer(
                      layoutId: widget.layoutId,
                      child: (({required bool displaySearchBar}) =>
                          displaySearchBar
                              ? ChannelSearchBar(
                                  key: Key(
                                      'channel-search-bar-${widget.layoutId}'),
                                )
                              : Container()),
                    ),
                    Obx(() => uiController.displayHomeNavigationBar.value
                        ? LayoutStyleTabBgColorConsumer(
                            layoutId: widget.layoutId,
                            child: (({required bool needTabBgColor}) =>
                                Container(
                                  color: needTabBgColor
                                      ? AppColors.colors[ColorKeys.primary]
                                      : Colors.transparent,
                                  height: 45,
                                  child: LayoutTabBar(
                                    layoutId: widget.layoutId,
                                  ),
                                )),
                          )
                        : const SizedBox.shrink()),
                  ],
                )),
                bottomNavigatorController.activeKey.value ==
                            HomeNavigatorPathes.layout1 &&
                        bottomNavigatorController.fabLink.isNotEmpty &&
                        bottomNavigatorController.displayFab.value
                    ? FloatingButton(
                        displayFab: displayFab,
                        onFabTap: () =>
                            bottomNavigatorController.setDisplayFab(false),
                      )
                    : const SizedBox.shrink()
              ],
            ));
          },
        ));
  }
}
