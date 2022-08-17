import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wgp_video_h5app/base/index.dart';
import 'package:wgp_video_h5app/base/layouts/index.dart';
import 'package:wgp_video_h5app/base/v_loading.dart';
import 'package:wgp_video_h5app/components/index.dart';
import 'package:wgp_video_h5app/controllers/index.dart';
import 'package:wgp_video_h5app/helpers/index.dart';
import 'package:wgp_video_h5app/providers/index.dart';
import 'package:wgp_video_h5app/styles.dart';

class PublisherPage extends StatefulWidget {
  const PublisherPage({Key? key}) : super(key: key);

  @override
  _PublisherPageState createState() => _PublisherPageState();
}

class _PublisherPageState extends State<PublisherPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late VPublisherController _vPublisherController;
  late final VTabCollection _tabCollection = VPublisherTabs();
  int publisherId = 0;
  int _currentIndex = 0;

  final Map<int, List<Widget>> _vodList = {0: [], 1: []};

  @override
  void initState() {
    publisherId = int.parse(Get.parameters['publisherId'] as String);
    _vPublisherController = Get.find<VPublisherController>();
    _tabController = TabController(
      vsync: this,
      initialIndex: _currentIndex,
      length: _tabCollection.getTabs().length,
    );
    _tabController.addListener(_handleTabChanged);
    _vPublisherController.getPublisher(publisherId);
    updateVodList();
    super.initState();
  }

  Future<void> updateVodList() async {
    if (!_vodList.containsKey(_currentIndex) ||
        _vodList[_currentIndex]?.isEmpty == false) {
      return;
    }
    PublisherProvider provider = Get.find();
    var loading = true;
    int page = 1;
    int limit = 100;
    while (loading) {
      BlockVod result;
      if (_currentIndex == 0) {
        result = await provider.getManyLatestVodBy(
          publisherId: publisherId,
          page: page++,
          limit: limit,
        );
      } else {
        result = await provider.getManyHottestVodBy(
          publisherId: publisherId,
          page: page++,
          limit: limit,
        );
      }
      loading = result.vods.isNotEmpty && result.vods.length == 100;
      _vodList.update(_currentIndex, (value) {
        var i = 0;
        while (i < result.vods.length) {
          var vod1 = result.vods[i++];
          var vod2 = (i >= result.vods.length) ? null : result.vods[i++];
          value.add(Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: (gs().width - 55) / 2,
                child: VBlockItemSmall(vod1, title: vod1.title),
              ),
              SizedBox(
                width: (gs().width - 55) / 2,
                child: vod2 == null
                    ? const SizedBox.shrink()
                    : VBlockItemSmall(vod2, title: vod2.title),
              ),
            ],
          ));
        }
        return value;
      });
    }
    await Future.delayed(const Duration(milliseconds: 555));
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChanged);
    _tabController.dispose();
    _vPublisherController.disposePublisher();
    super.dispose();
  }

  void _handleTabChanged() {
    if (_currentIndex != _tabController.index) {
      setState(() {
        _currentIndex = _tabController.index;
      });
      updateVodList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        // title: Text(widget.title),
        backgroundColor: color1,
        shadowColor: Colors.transparent,
        toolbarHeight: 48,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: color1,
        ),
        leading: InkWell(
          onTap: () {
            back();
          },
          enableFeedback: true,
          child: const Icon(
            Icons.arrow_back_ios,
            size: 14,
          ),
        ),
        title: Stack(
          children: [
            Transform(
              transform: Matrix4.translationValues(-26, 0, 0),
              child: Center(
                child: Text(
                  _vPublisherController.publisher.name.isEmpty
                      ? '出版商'
                      : _vPublisherController.publisher.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
            Transform(
              transform: Matrix4.translationValues(0, 5, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const VDIcon(VIcons.view_black),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    '${_vPublisherController.publisher.containVideos ?? 0}',
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: VDStickyTabBarDelegate(
                backgroundColor: color7,
                child: VDStickyTabBar(
                  tabController: _tabController,
                  currentIndex: _currentIndex,
                  controller: _tabCollection,
                  tabBarType: 2,
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 10,
              ),
            ),
            SliverFillRemaining(
              child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: _tabCollection
                    .getTabs()
                    .map(
                      (key, value) => MapEntry(
                        key,
                        VDVodListView(
                          vodList: _vodList[key] ?? [],
                        ),
                      ),
                    )
                    .values
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VDVodListView extends StatefulWidget {
  final List<Widget> vodList;

  const VDVodListView({
    Key? key,
    required this.vodList,
  }) : super(key: key);

  @override
  State<VDVodListView> createState() => _VDVodListViewState();
}

class _VDVodListViewState extends State<VDVodListView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => widget.vodList.isNotEmpty;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.vodList.isEmpty
        ? SizedBox(
            width: gs().width,
            height: gs().height - 60,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                VLoading(),
                SizedBox(
                  height: 10,
                ),
                Text("讀取中..."),
              ],
            ),
          )
        : CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_c, _id) {
                      var _widget = widget.vodList[_id];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 8,
                        ),
                        child: _widget,
                      );
                    },
                    childCount: widget.vodList.length,
                  ),
                ),
              ),
            ],
          );
  }
}
