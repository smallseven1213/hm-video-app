import 'package:app_gs/screens/main_screen/channels.dart';
import 'package:app_gs/widgets/wave_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/layout_controller.dart';
import 'package:shared/widgets/display_layout_tab_search.dart';

import 'channel_search_bar.dart';
import 'layout_tab_bar.dart';

class HomeMainScreen extends StatelessWidget {
  final int layoutId;
  const HomeMainScreen({Key? key, required this.layoutId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GetBuilder<LayoutController>(
        tag: 'layout$layoutId',
        builder: (controller) {
          return Obx(() {
            if (controller.isLoading.value) {
              return const Scaffold(
                body: Center(
                  child:
                      Text('loading 2', style: TextStyle(color: Colors.white)),
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
                      child: ChannelSearchBar(),
                    )
                  ],
                )),
              ],
            ));
          });
        },
      ),
    );
  }
}
