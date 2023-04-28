import 'package:app_gs/screens/main_screen/channels.dart';
import 'package:app_gs/screens/main_screen/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/layout_controller.dart';

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
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(88),
              child: Padding(
                padding:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: Column(children: [
                  Expanded(
                      child: LayoutTabBar(
                    key: Key('layout-tab-bar-$layoutId'),
                    layoutId: layoutId,
                  )),
                  Expanded(
                    child: SearchBar(),
                  )
                ]),
                // Expanded(
                //   child: Marquee(),
                // ),
              ),
            ),
            body: Channels(layoutId: layoutId),
          );
        },
      ),
    );
  }
}
