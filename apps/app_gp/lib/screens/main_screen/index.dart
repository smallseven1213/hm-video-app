import 'package:app_gp/screens/main_screen/channels.dart';
import 'package:app_gp/screens/main_screen/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/banner_controller.dart';
import 'package:shared/controllers/channel_screen_tab_controller.dart';
import 'package:shared/controllers/layout_controller.dart';

import 'layout_tab_bar.dart';

class HomeMainScreen extends StatefulWidget {
  final int layoutId;
  const HomeMainScreen({Key? key, required this.layoutId}) : super(key: key);

  @override
  HomeMainScreenState createState() => HomeMainScreenState();
}

class HomeMainScreenState extends State<HomeMainScreen> {
  BannerController bannerController = Get.find<BannerController>();

  @override
  void initState() {
    super.initState();
    logger.i('INITIAL-HOME');

    Get.put(ChannelScreenTabController(),
        tag: 'channel-screen-${widget.layoutId}', permanent: false);
    Get.put(LayoutController(widget.layoutId.toString()),
        tag: 'layout${widget.layoutId}', permanent: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(88),
        child: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: Column(
            children: [
              Expanded(
                child: SearchBar(),
              ),
              Expanded(
                child: LayoutTabBar(
                  key: ValueKey(widget.layoutId),
                  layoutId: widget.layoutId,
                ),
              ),
              // Expanded(
              //   child: Marquee(),
              // ),
            ],
          ),
        ),
      ),
      body: Channels(layoutId: widget.layoutId),
    );
  }
}
