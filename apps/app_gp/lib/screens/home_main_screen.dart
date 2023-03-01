import 'package:app_gp/screens/main_screen/marquee.dart';
import 'package:app_gp/screens/main_screen/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/layout_controller.dart';

import 'main_screen/channel.dart';
import 'main_screen/tab_bar.dart';

class HomeMainScreen extends StatelessWidget {
  HomeMainScreen({Key? key}) : super(key: key);

  final layoutController = Get.find<LayoutController>(tag: 'layout1');

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Home'),
      // ),

      // appBar is a custom PreferredSize view
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(200),
        child: Column(
          children: [
            Expanded(
              child: SearchBar(),
            ),
            Expanded(
              child: Tabbar(),
            ),
            Expanded(
              child: Marquee(),
            ),
          ],
        ),
      ),
      body: PageView(
        controller: controller,
        allowImplicitScrolling: true,
        children: const [
          MainChannelScreen(
            channelId: '1',
          ),
          MainChannelScreen(
            channelId: '2',
          ),
          MainChannelScreen(
            channelId: '3',
          ),
          MainChannelScreen(
            channelId: '4',
          ),
        ],
      ),
    );
  }
}
