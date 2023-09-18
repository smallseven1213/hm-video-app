import 'package:app_sv/config/colors.dart';
import 'package:app_sv/screens/main_screen/channels.dart';
import 'package:app_sv/screens/video/video_player_area/flash_loading.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/modules/main_layout/display_layout_tab_search_consumer.dart';
import 'package:shared/modules/main_layout/main_layout_loading_status_consumer.dart';
import 'package:shared/modules/main_layout/layout_style_tab_bg_consumer.dart';

import 'channel_search_bar.dart';
import 'layout_tab_bar.dart';

class HomeMainScreen extends StatelessWidget {
  final int layoutId;
  const HomeMainScreen({Key? key, required this.layoutId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    LayoutStyleTabBgColorConsumer(
                      layoutId: layoutId,
                      child: (({required bool needTabBgColor}) => Container(
                            color: needTabBgColor
                                ? AppColors.colors[ColorKeys.primary]
                                : Colors.transparent,
                            height: 45,
                            child: LayoutTabBar(
                              layoutId: layoutId,
                            ),
                          )),
                    ),
                  ],
                )),
              ],
            ));
          },
        ));
  }
}
