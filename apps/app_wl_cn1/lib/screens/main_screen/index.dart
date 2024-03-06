import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared/controllers/ui_controller.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/modules/main_layout/display_layout_tab_search_consumer.dart';
import 'package:shared/modules/main_layout/main_layout_loading_status_consumer.dart';
import 'package:shared/modules/main_layout/layout_style_tab_bg_consumer.dart';

import 'package:app_wl_cn1/config/colors.dart';
import 'package:app_wl_cn1/screens/main_screen/channels.dart';
import 'package:app_wl_cn1/screens/video/video_player_area/flash_loading.dart';

import 'channel_search_bar.dart';
import 'layout_tab_bar.dart';

class HomeMainScreen extends StatelessWidget {
  final int layoutId;
  final uiController = Get.find<UIController>();

  HomeMainScreen({Key? key, required this.layoutId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        child: MainLayoutLoadingStatusConsumer(
          layoutId: layoutId,
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
                  key: Key('channels-$layoutId'),
                  layoutId: layoutId,
                ),
                Positioned(
                    child: Column(
                  children: [
                    LayoutStyleTabBgColorConsumer(
                      layoutId: layoutId,
                      child: (({required bool needTabBgColor}) => Container(
                            color: needTabBgColor
                                ? AppColors.colors[ColorKeys.primary]
                                : Colors.transparent,
                            height: MediaQuery.paddingOf(context).top,
                          )),
                    ),
                    DisplayLayoutTabSearchConsumer(
                      layoutId: layoutId,
                      child: (({required bool displaySearchBar}) =>
                          displaySearchBar
                              ? ChannelSearchBar(
                                  key: Key('channel-search-bar-$layoutId'),
                                )
                              : Container()),
                    ),
                    Obx(() => uiController.displayHomeNavigationBar.value
                        ? LayoutStyleTabBgColorConsumer(
                            layoutId: layoutId,
                            child: (({required bool needTabBgColor}) =>
                                Container(
                                  color: needTabBgColor
                                      ? AppColors.colors[ColorKeys.primary]
                                      : Colors.transparent,
                                  height: 45,
                                  child: LayoutTabBar(
                                    layoutId: layoutId,
                                  ),
                                )),
                          )
                        : const SizedBox.shrink()),
                  ],
                )),
              ],
            ));
          },
        ));
  }
}
