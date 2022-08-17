import 'dart:math';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wgp_video_h5app/base/layouts/index.dart';
import 'package:wgp_video_h5app/base/v_loading.dart';
import 'package:wgp_video_h5app/controllers/index.dart';
import 'package:wgp_video_h5app/helpers/index.dart';
import 'package:wgp_video_h5app/models/index.dart';
import 'package:wgp_video_h5app/providers/index.dart';
import 'package:wgp_video_h5app/styles.dart';

class BlockMorePage extends StatefulWidget {
  const BlockMorePage({Key? key}) : super(key: key);

  @override
  _BlockMorePageState createState() => _BlockMorePageState();
}

class _BlockMorePageState extends State<BlockMorePage> {
  final _refreshController = RefreshController(initialRefresh: false);
  List<Vod> vods = [];
  List<Widget> vodList = [];
  int totalVods = 0;
  bool loading = true;
  String areaTitle = '';
  CancelableOperation? cancelToken;

  Future<void> loadVod() async {
    int page = 1;
    VodProvider vodProvider = Get.find();
    var channelId = int.parse(Get.parameters['channelId'].toString());
    var blockId = int.parse(Get.parameters['blockId'].toString());
    var limit = 500;
    var _loading = true;
    var result = await vodProvider.getMoreMany(
      blockId,
      page: page++,
      limit: limit,
    );
    _loading = result.vods.isNotEmpty && result.vods.length == limit;
    vods.addAll(result.vods);
    Future.microtask(() async {
      while (_loading) {
        var result = await vodProvider.getMoreMany(
          blockId,
          page: page++,
          limit: limit,
        );
        _loading = result.vods.isNotEmpty && result.vods.length == limit;
        vods.addAll(result.vods);
        renderList(blockId, channelId, result.vods);
      }
      setState(() {});
    });
    renderList(blockId, channelId, result.vods);
    setState(() {
      totalVods = result.total;
      loading = false;
    });
  }

  void renderList(blockId, channelId, vods) {
    var channel = Get.find<VChannelController>()
        .channels
        .firstWhere((element) => element.id == channelId);
    var banners = Get.find<HomeController>().cachedChannelBanners[channel];
    var area = (Get.find<HomeController>().cachedBlocks[channel] ?? [])
        .firstWhere((element) => element.id == blockId);
    var showAds = area.isAreaAds ?? false;
    var ads = banners?.blockBanners[blockId]?.banners ?? [];

    areaTitle = area.name;
    var tmp = vods;
    var i = 0;
    while (i < tmp.length) {
      var vod1 = tmp[i++];
      var vod2 = (i >= tmp.length) ? null : tmp[i++];
      vodList.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: (gs().width - 18) / 2,
              child: VBlockItemSmall(
                vod1,
                title: vod1.title,
              ),
            ),
            SizedBox(
              width: (gs().width - 18) / 2,
              child: vod2 == null
                  ? const SizedBox.shrink()
                  : VBlockItemSmall(
                      vod2,
                      title: vod2.title,
                    ),
            )
          ],
        ),
      );
      if (showAds && ads.isNotEmpty && i % 8 == 0) {
        ads.shuffle(Random());
        vodList.add(VBlockAd(
          bannerId: ads.first.id,
          photoSid: ads.first.photoSid,
          url: ads.first.url,
        ));
      }
    }
    // if (showAds && ads.isNotEmpty) {
    //   ads.shuffle(Random());
    //   vodList.add(VBlockAd(
    //     bannerId: ads.first.id,
    //     photoSid: ads.first.photoSid,
    //     url: ads.first.url,
    //   ));
    // }
  }

  @override
  void initState() {
    loadVod();
    super.initState();
  }

  @override
  void dispose() {
    cancelToken?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        // title: Text(widget.title),
        backgroundColor: mainBgColor,
        shadowColor: Colors.transparent,
        toolbarHeight: 48,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: mainBgColor,
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
        title: Transform(
          transform: Matrix4.translationValues(-26, 0, 0),
          child: Center(
            child: Text(
              areaTitle,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: loading
            ? SizedBox(
                width: gs().width,
                height: gs().height - 40,
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
            : SmartRefresher(
                enablePullDown: false,
                enablePullUp: true,
                footer: CustomFooter(
                  builder: (_ctx, LoadStatus? mode) {
                    if (mode == LoadStatus.loading) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    if (mode == LoadStatus.noMore) {
                      Future.delayed(const Duration(seconds: 3)).then((value) {
                        _refreshController.loadComplete();
                        setState(() {});
                      });
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: Text(
                            '沒有更多了',
                            style: TextStyle(color: color5),
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                onLoading: () async {
                  _refreshController.requestLoading();
                  await Future.delayed(const Duration(seconds: 1));
                  setState(() {});
                  _refreshController.loadNoData();
                },
                onRefresh: () {
                  _refreshController.refreshCompleted();
                },
                controller: _refreshController,
                child: CustomScrollView(
                  cacheExtent: gs().height,
                  primary: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Container(
                        width: gs().width,
                        padding: const EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                        ),
                        decoration: const BoxDecoration(
                          color: color7,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '已找到$totalVods視頻',
                          style: const TextStyle(
                            color: color5,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 15,
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (_c, _id) {
                            var _widget = vodList[_id];
                            return Padding(
                              padding: const EdgeInsets.only(
                                bottom: 6,
                              ),
                              child: _widget,
                            );
                          },
                          childCount: vodList.length,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
