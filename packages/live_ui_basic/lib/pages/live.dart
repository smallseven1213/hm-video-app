import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_core/controllers/live_list_controller.dart';
import 'package:live_core/widgets/live_scaffold.dart';
import 'package:live_core/widgets/room_list_provider.dart';

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
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreData();
    }
  }

  void _loadMoreData() {
    final LiveListController controller = Get.find<LiveListController>();
    controller.fetchData(isLoadMore: true);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LiveScaffold(
      backgroundColor: const Color(0xFF242a3d),
      body: RoomListProvider(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: const [
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
          ],
        ),
      ),
    );
  }
}
