import 'package:logger/logger.dart';

import 'package:app_51ss/config/colors.dart';
import 'package:app_51ss/screens/main_screen/channels.dart';
import 'package:app_51ss/screens/video/video_player_area/flash_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/layout_controller.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/modules/main_layout/display_layout_tab_search_consumer.dart';
import 'package:shared/modules/main_layout/main_layout_loading_status_consumer.dart';

import 'channel_search_bar.dart';
import 'layout_tab_bar.dart';

var logger = Logger();

class HomeMainScreen extends StatelessWidget {
  final int layoutId;
  const HomeMainScreen({Key? key, required this.layoutId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var layoutController = Get.find<LayoutController>(tag: 'layout$layoutId');

    return WillPopScope(
        onWillPop: () async => false,
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
                    Container(
                      color: AppColors.colors[ColorKeys.primary],
                      height: MediaQuery.of(context).padding.top,
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
                    Obx(() {
                      logger.i(
                          'layoutController style: ${layoutController.style.value}');
                      return Container(
                        color: layoutController.style.value != 6 ||
                                layoutController.style.value != 2
                            ? AppColors.colors[ColorKeys.primary]
                            : Colors.transparent,
                        height: 45,
                        child: LayoutTabBar(
                          layoutId: layoutId,
                        ),
                      );
                    })
                  ],
                )),
              ],
            ));
          },
        ));
  }
}
