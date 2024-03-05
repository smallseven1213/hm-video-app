// create a list of rank, which is a stateful widget

// Path: packages/live_ui_basic/lib/screens/rank/list.dart
// Compare this snippet from packages/live_ui_basic/lib/screens/live_room/rank.dart:

// UI for rank list, which has a appBar called 主播排行
// and a tabView with three tabs 綜合,人氣,新人

import 'package:flutter/material.dart';

import '../../localization/live_localization_delegate.dart';

class StreamerRankPage extends StatefulWidget {
  const StreamerRankPage({Key? key}) : super(key: key);

  @override
  _StreamerRankPageState createState() => _StreamerRankPageState();
}

class _StreamerRankPageState extends State<StreamerRankPage> {
  @override
  Widget build(BuildContext context) {
    final LiveLocalizations localizations = LiveLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.translate('host_ranking'),
            style: const TextStyle(fontSize: 14)),
        centerTitle: true,
      ),
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF242a3d),
            bottom: TabBar(
              tabs: [
                Tab(text: localizations.translate('comprehensive')),
                Tab(text: localizations.translate('popularity')),
                Tab(text: localizations.translate('newcomer')),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Center(child: Text(localizations.translate('comprehensive'))),
              Center(child: Text(localizations.translate('popularity'))),
              Center(child: Text(localizations.translate('newcomer'))),
            ],
          ),
        ),
      ),
    );
  }
}
