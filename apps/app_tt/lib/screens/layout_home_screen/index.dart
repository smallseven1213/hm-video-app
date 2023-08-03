import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/layout_controller.dart';
import 'package:shared/widgets/display_layout_tab_search.dart';

import '../../widgets/wave_loading.dart';
import 'channel_search_bar.dart';
import 'channels.dart';
import 'layout_tab_bar.dart';

class LayoutHomeScreen extends StatelessWidget {
  final int layoutId;
  const LayoutHomeScreen({Key? key, required this.layoutId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GetBuilder<LayoutController>(
        tag: 'layout$layoutId',
        builder: (controller) {
          if (controller.isLoading.value) {
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
                  SizedBox(
                    height: MediaQuery.of(context).padding.top,
                  ),
                  SizedBox(
                    height: 38,
                    child: LayoutTabBar(
                      key: Key('layout-tab-bar-$layoutId'),
                      layoutId: layoutId,
                    ),
                  ),
                  DisplayLayoutTabSearch(
                      layoutId: layoutId,
                      child: (({required bool displaySearchBar}) =>
                          displaySearchBar
                              ? ChannelSearchBar(
                                  key: Key('channel-search-bar-$layoutId'),
                                )
                              : Container()))
                ],
              )),
            ],
          ));
        },
      ),
    );
  }
}
