import 'package:app_gp/screens/main_screen/channels.dart';
import 'package:app_gp/screens/main_screen/marquee.dart';
import 'package:app_gp/screens/main_screen/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/layout_controller.dart';
import 'package:shared/controllers/channel_screen_tab_controller.dart';

import 'tab_bar.dart';

class HomeMainScreen extends StatefulWidget {
  HomeMainScreen({Key? key}) : super(key: key);

  @override
  _HomeMainScreenState createState() => _HomeMainScreenState();
}

class _HomeMainScreenState extends State<HomeMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(120),
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
        body: Channels());
  }
}
