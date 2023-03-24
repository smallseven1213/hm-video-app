import 'package:app_gp/screens/main_screen/channels.dart';
import 'package:app_gp/screens/main_screen/marquee.dart';
import 'package:app_gp/screens/main_screen/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/banner_controller.dart';

import 'notice_dialog.dart';
import 'layout_tab_bar.dart';

class HomeMainScreen extends StatefulWidget {
  const HomeMainScreen({Key? key}) : super(key: key);

  @override
  HomeMainScreenState createState() => HomeMainScreenState();
}

class HomeMainScreenState extends State<HomeMainScreen> {
  BannerController bannerController = Get.find<BannerController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(88),
        child: Column(
          children: const [
            Expanded(
              child: LayoutTabBar(),
            ),
            Expanded(
              child: SearchBar(),
            ),
            // Expanded(
            //   child: Marquee(),
            // ),
          ],
        ),
      ),
      body: Stack(
        children: const [Channels(), NoticeDialog()],
      ),
    );
  }
}
