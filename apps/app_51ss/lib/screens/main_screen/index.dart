import 'package:app_51ss/screens/main_screen/channels.dart';
import 'package:app_51ss/widgets/wave_loading.dart';
import 'package:flutter/material.dart';
import 'package:shared/modules/main_layout/display_layout_tab_search_consumer.dart';
import 'package:shared/modules/main_layout/main_layout_loading_status_consumer.dart';

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
                body: Center(
                  child: WaveLoading(
                    color: Color.fromRGBO(255, 255, 255, 0.3),
                    duration: Duration(milliseconds: 1000),
                    size: 17,
                    itemCount: 3,
                  ),
                ),
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
                    DisplayLayoutTabSearchConsumer(
                      layoutId: layoutId,
                      child: (({required bool displaySearchBar}) =>
                          displaySearchBar
                              ? ChannelSearchBar(
                                  key: Key('channel-search-bar-$layoutId'),
                                )
                              : Container()),
                    ),
                    SizedBox(
                      height: 45,
                      child: LayoutTabBar(
                        layoutId: layoutId,
                      ),
                    ),
                  ],
                )),
              ],
            ));
          },
        ));
  }
}
