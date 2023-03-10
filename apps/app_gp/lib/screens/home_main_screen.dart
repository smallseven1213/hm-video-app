import 'package:app_gp/screens/main_screen/channels.dart';
import 'package:app_gp/screens/main_screen/marquee.dart';
import 'package:app_gp/screens/main_screen/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/banner_controller.dart';
import 'package:shared/controllers/layout_controller.dart';
import 'package:shared/controllers/channel_screen_tab_controller.dart';

import 'main_screen/channel.dart';
import 'main_screen/notice_dialog.dart';
import 'main_screen/tab_bar.dart';

class HomeMainScreen extends StatefulWidget {
  HomeMainScreen({Key? key}) : super(key: key);

  @override
  _HomeMainScreenState createState() => _HomeMainScreenState();
}

class _HomeMainScreenState extends State<HomeMainScreen> {
  BannerController bannerController = Get.find<BannerController>();

  @override
  void initState() {
    // TODO: implement initState
    // 入站廣告 banners/banner/position?positionId=5
    // 進入大廳用戶事件紀錄 user/userEventRecord/enterHall
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(200),
        child: Column(
          children: [
            NoticeDialog(),
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
      body: Channels(),
    );
  }
}
