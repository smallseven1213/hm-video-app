import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_core/controllers/live_list_controller.dart';
import 'package:live_core/widgets/live_scaffold.dart';
import 'package:live_core/widgets/room_list_provider.dart';

import '../screens/live/banners.dart';
import '../screens/live/filter.dart';
import '../screens/live/list.dart';
import '../screens/live/live_skelton.dart';
import '../screens/live/loading_text.dart';
import '../screens/live/navigation.dart';
import '../screens/live/search.dart';
import '../screens/live/sort.dart';
import '../screens/live/no_more.dart';

class LivePage extends StatefulWidget {
  const LivePage({Key? key}) : super(key: key);
  @override
  LivePageState createState() => LivePageState();
}

class LivePageState extends State<LivePage> {
  final ScrollController _scrollController = ScrollController();
  bool noMore = false;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    const threshold = 30;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - threshold) {
      _loadMoreData();
    }
  }

  void _loadMoreData() {
    final LiveListController controller = Get.find<LiveListController>();
    if (!controller.hasMore.value) {
      setState(() {
        noMore = true;
      });
      // delay 3 seconds to show no more widget
      Future.delayed(const Duration(seconds: 3), () {
        setState(() {
          noMore = false;
        });
      });
      return;
    } else if (controller.isLoading.value) {
      return;
    }
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
      appBar: AppBar(
        backgroundColor: const Color(0xFF242a3d),
        flexibleSpace: const Padding(
          padding: EdgeInsets.only(left: 10, right: 10, top: 10),
          child: SearchWidget(),
        ),
      ),
      loadingWidget: const LiveSkeleton(),
      backgroundColor: const Color(0xFF242a3d),
      body: RoomListProvider(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            const SliverToBoxAdapter(
              child: SizedBox(height: 10),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: BannersWidget(), // 確保 BannersWidget 支持這種布局
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 10),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: NavigationWidget(),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 10),
            ),
            const SliverToBoxAdapter(
                child: Padding(
              padding: EdgeInsets.only(right: 10),
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                FilterWidget(),
                SizedBox(width: 16),
                SortWidget(),
              ]),
            )),
            const SliverToBoxAdapter(
              child: SizedBox(height: 10),
            ),
            const SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              sliver: LiveList(),
            ),
            const LoadingTextWidget(),
            if (noMore) const SliverToBoxAdapter(child: NoMoreWidget()),
          ],
        ),
      ),
    );
  }
}
