import 'package:flutter/material.dart';
import 'package:live_core/widgets/live_scaffold.dart';

import '../screens/live/banners.dart';
import '../screens/live/filter.dart';
import '../screens/live/list.dart';
import '../screens/live/navigation.dart';
import '../screens/live/search.dart';
import '../screens/live/sort.dart';

class LivePage extends StatefulWidget {
  const LivePage({Key? key}) : super(key: key);
  @override
  _LivePageState createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const LiveScaffold(
      backgroundColor: Color(0xFF242a3d),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(height: 50),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: SearchWidget(),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 10),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: BannersWidget(), // 確保 BannersWidget 支持這種布局
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 10),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: NavigationWidget(),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 10),
          ),
          SliverToBoxAdapter(
              child: Padding(
            padding: EdgeInsets.only(right: 10),
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              FilterWidget(),
              SizedBox(width: 16),
              SortWidget(),
            ]),
          )),
          SliverToBoxAdapter(
            child: SizedBox(height: 10),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            sliver: LiveList(),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 10),
          ),
          // 測試用
          // SliverToBoxAdapter(
          //   child: TextButton(
          //     onPressed: () {
          //       MyRouteDelegate.of(context).push(
          //         "/live_room",
          //         // args: {"pid": room.pid},
          //         args: {"pid": 347},
          //       );
          //     },
          //     child: const Text("Test Room"),
          //   ),
          // ),
        ],
      ),
    );
  }
}
