import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_core/controllers/live_list_controller.dart';
import 'package:live_core/widgets/live_scaffold.dart';

import '../screens/live/banners.dart';
import '../screens/live/list.dart';
import '../screens/live/room_item.dart';
import '../screens/live/search.dart';

class LivePage extends StatefulWidget {
  const LivePage({Key? key}) : super(key: key);
  @override
  _LivePageState createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> {
  @override
  Widget build(BuildContext context) {
    return LiveScaffold(
      backgroundColor: const Color(0xFF242a3d),
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: SizedBox(height: 50),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: SearchWidget(),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 10),
          ),
          // ratio w 341 : h 143 , change to Ratio Widget
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: BannersWidget(), // 確保 BannersWidget 支持這種布局
            ),
          ),
          // h 10
          const SliverToBoxAdapter(
            child: SizedBox(height: 10),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            sliver: LiveList(),
          ),
        ],
      ),
    );
  }
}
