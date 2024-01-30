// create a list of rank, which is a stateful widget

// Path: packages/live_ui_basic/lib/screens/rank/list.dart
// Compare this snippet from packages/live_ui_basic/lib/screens/live_room/rank.dart:

// UI for rank list, which has a appBar called 主播排行
// and a tabView with three tabs 綜合,人氣,新人

import 'package:flutter/material.dart';

class StreamerRankPage extends StatefulWidget {
  const StreamerRankPage({Key? key}) : super(key: key);

  @override
  _StreamerRankPageState createState() => _StreamerRankPageState();
}

class _StreamerRankPageState extends State<StreamerRankPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('主播排行'),
        centerTitle: true,
      ),
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF242a3d),
            bottom: const TabBar(
              tabs: [
                Tab(text: '綜合'),
                Tab(text: '人氣'),
                Tab(text: '新人'),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              Center(child: Text('綜合')),
              Center(child: Text('人氣')),
              Center(child: Text('新人')),
            ],
          ),
        ),
      ),
    );
  }
}
