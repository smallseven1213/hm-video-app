// ChannelStyle2 is a stateless widget, return Text 'STYLE 2
import 'package:app_gs/screens/main_screen/channel_style_3/vods.dart';
import 'package:flutter/material.dart';

import '../../../widgets/header.dart';
import '../../../widgets/tab_bar.dart';

class ChannelStyle3 extends StatefulWidget {
  final int channelId;
  const ChannelStyle3({Key? key, required this.channelId}) : super(key: key);

  @override
  _ChannelStyle3State createState() => _ChannelStyle3State();
}

class _ChannelStyle3State extends State<ChannelStyle3>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final ScrollController _parentScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            // height 50 box
            SliverToBoxAdapter(
              child: Container(
                height: 50,
                color: Colors.white,
              ),
            ),
            SliverAppBar(
              pinned: true,
              leading: null,
              automaticallyImplyLeading: false,
              forceElevated: true,
              expandedHeight: 0,
              toolbarHeight: 0,
              flexibleSpace: const SizedBox.shrink(),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(60),
                child: SizedBox(
                    height: 60,
                    child: GSTabBar(
                      controller: _tabController,
                      tabs: const ['最新', '最熱'],
                    )),
              ),
            ),
          ];
        },
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: [
            Vods(
              scrollController: _parentScrollController,
            ),
            Vods(
              scrollController: _parentScrollController,
            ),
          ],
        ),
      ),
    );
  }
}
