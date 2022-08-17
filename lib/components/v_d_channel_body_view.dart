import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wgp_video_h5app/base/index.dart';
import 'package:wgp_video_h5app/base/layouts/index.dart';
import 'package:wgp_video_h5app/base/layouts/v_block_header.dart';
import 'package:wgp_video_h5app/base/v_loading.dart';
import 'package:wgp_video_h5app/components/index.dart';
import 'package:wgp_video_h5app/controllers/index.dart';
import 'package:wgp_video_h5app/helpers/getx.dart';
import 'package:wgp_video_h5app/models/index.dart';
import 'package:wgp_video_h5app/providers/index.dart';
import 'package:wgp_video_h5app/styles.dart';

class VDChannelBodyView extends StatefulWidget {
  final int currentIndex;
  final Channel channel;

  const VDChannelBodyView({
    Key? key,
    required this.channel,
    required this.currentIndex,
  }) : super(key: key);

  @override
  _VDChannelBodyViewState createState() => _VDChannelBodyViewState();
}

class _VDChannelBodyViewState extends State<VDChannelBodyView>
    with AutomaticKeepAliveClientMixin {
  final _refreshController = RefreshController(initialRefresh: false);

  @override
  bool get wantKeepAlive => true;
  // _homeController.channelLoaded[widget.channel.id] ?? false;

  ChannelBanner? banners;
  List<Block> areas = [];
  List<Widget> vodList = [];
  Map<int, int> vodListOffset = {};
  bool showBottom = false;

  final ScrollController _scrollController = ScrollController();
  final HomeController _homeController = Get.find<HomeController>();

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.offset + 20 >
          _scrollController.position.maxScrollExtent) {
        setState(() {
          showBottom = true;
        });
      }
    });
    updateVodList();
    super.initState();
  }

  void updateVodList() {
    setState(() {
      banners = _homeController.cachedChannelBanners[widget.channel];
      areas = _homeController.cachedBlocks[widget.channel] ?? [];
      vodList = areas.map((area) {
        var showAds = area.isAreaAds ?? false;
        var ads = banners?.blockBanners[area.id]?.banners ?? [];
        var blockVod = _homeController.cachedBlockVods[area.id];
        if (!vodListOffset.containsKey(area.id)) {
          vodListOffset.putIfAbsent(area.id, () => 1);
        }
        List<Widget> _list = [
          VBlockHeader(
            area,
            widget.channel,
            refresh: () async {
              // TODO: refresh & state management
              var rerun = true;
              while (rerun) {
                var offset = vodListOffset[area.id] ?? 0;
                var result = await Get.find<VodProvider>()
                    .getManyByChannel(area.id, offset: offset + 1);
                if (result.vods.isNotEmpty) {
                  _homeController.cachedBlockVods[area.id] = result;
                  updateVodList();
                  vodListOffset.update(area.id, (value) => offset + 1);
                  rerun = false;
                } else {
                  vodListOffset.update(area.id, (value) => 0);
                }
              }
            },
          ),
        ];
        if (area.template == 1) {
          var tmp = blockVod?.vods ?? [];
          var i = 0;
          while (i < tmp.length) {
            if (i % 5 == 0) {
              var vod = tmp[i++];
              _list.add(
                SizedBox(
                  width: gs().width - 16,
                  child: VBlockItemBig(
                    vod,
                    title: vod.title,
                  ),
                ),
              );
              continue;
            }
            var vod1 = tmp[i++];
            var vod2 = (i >= tmp.length) ? null : tmp[i++];
            _list.add(
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: (gs().width - 24) / 2,
                    child: VBlockItemSmall(
                      vod1,
                      title: vod1.title,
                    ),
                  ),
                  SizedBox(
                    width: (gs().width - 24) / 2,
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

            if (showAds && ads.isNotEmpty && i % 5 == 0 && i < tmp.length - 5) {
              ads.shuffle(Random());
              _list.add(VBlockAd(
                bannerId: ads.first.id,
                photoSid: ads.first.photoSid,
                url: ads.first.url,
              ));
            }
          }
          if (showAds && ads.isNotEmpty) {
            ads.shuffle(Random());
            _list.add(VBlockAd(
              bannerId: ads.first.id,
              photoSid: ads.first.photoSid,
              url: ads.first.url,
            ));
          }
        } else if (area.template == 2) {
          var tmp = blockVod?.vods ?? [];
          var i = 0;
          while (i < tmp.length) {
            var vod = tmp[i++];
            _list.add(
              SizedBox(
                width: gs().width - 16,
                child: VBlockItemBig(
                  vod,
                  title: vod.title,
                ),
              ),
            );
            if (showAds && ads.isNotEmpty && i % 4 == 0 && i < tmp.length - 1) {
              ads.shuffle(Random());
              _list.add(VBlockAd(
                bannerId: ads.first.id,
                photoSid: ads.first.photoSid,
                url: ads.first.url,
              ));
            }
          }
          if (showAds && ads.isNotEmpty) {
            ads.shuffle(Random());
            _list.add(VBlockAd(
              bannerId: ads.first.id,
              photoSid: ads.first.photoSid,
              url: ads.first.url,
            ));
          }
        } else if (area.template == 3) {
          var tmp = blockVod?.vods ?? [];
          var i = 0;
          while (i < tmp.length) {
            var vod1 = tmp[i++];
            var vod2 = (i >= tmp.length) ? null : tmp[i++];
            _list.add(
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: (gs().width - 24) / 2,
                    child: VBlockItemSmall(
                      vod1,
                      title: vod1.title,
                    ),
                  ),
                  SizedBox(
                    width: (gs().width - 24) / 2,
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
            if (showAds && ads.isNotEmpty && i % 6 == 0 && i < tmp.length - 5) {
              ads.shuffle(Random());
              _list.add(VBlockAd(
                bannerId: ads.first.id,
                photoSid: ads.first.photoSid,
                url: ads.first.url,
              ));
            }
          }
          if (showAds && ads.isNotEmpty) {
            ads.shuffle(Random());
            _list.add(VBlockAd(
              bannerId: ads.first.id,
              photoSid: ads.first.photoSid,
              url: ads.first.url,
            ));
          }
        } else if (area.template == 4) {
          var tmp = blockVod?.vods ?? [];
          var i = 0;
          while (i < tmp.length) {
            var vod1 = tmp[i++];
            var vod2 = (i >= tmp.length) ? null : tmp[i++];
            var vod3 = (i >= tmp.length) ? null : tmp[i++];
            _list.add(
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: (gs().width - 32) / 3,
                    child: VBlockItemVertical(
                      vod1,
                      title: vod1.title,
                    ),
                  ),
                  SizedBox(
                    width: (gs().width - 32) / 3,
                    child: vod2 == null
                        ? const SizedBox.shrink()
                        : VBlockItemVertical(
                            vod2,
                            title: vod2.title,
                          ),
                  ),
                  SizedBox(
                    width: (gs().width - 32) / 3,
                    child: vod3 == null
                        ? const SizedBox.shrink()
                        : VBlockItemVertical(
                            vod3,
                            title: vod3.title,
                          ),
                  ),
                ],
              ),
            );
            if (showAds && ads.isNotEmpty && i % 6 == 0 && i < tmp.length - 6) {
              ads.shuffle(Random());
              _list.add(VBlockAd(
                bannerId: ads.first.id,
                photoSid: ads.first.photoSid,
                url: ads.first.url,
              ));
            }
          }
          if (showAds && ads.isNotEmpty) {
            ads.shuffle(Random());
            _list.add(VBlockAd(
              bannerId: ads.first.id,
              photoSid: ads.first.photoSid,
              url: ads.first.url,
            ));
          }
        } else if (area.template == 5) {
          var tmp = blockVod?.vods ?? [];
          _list.add(SizedBox(
            height: 115,
            child: CustomScrollView(
              primary: false,
              physics: const ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_c, _id) {
                      var vod = tmp[_id];
                      return Padding(
                        padding: const EdgeInsets.only(right: 6.0),
                        child: SizedBox(
                          width: (gs().width - 18) / 2.4,
                          child: VBlockItemSmall(
                            vod,
                            title: vod.title.toString(),
                          ),
                        ),
                      );
                    },
                    childCount: tmp.length,
                  ),
                ),
              ],
            ),
          ));
          if (showAds && ads.isNotEmpty) {
            ads.shuffle(Random());
            _list.add(VBlockAd(
              bannerId: ads.first.id,
              photoSid: ads.first.photoSid,
              url: ads.first.url,
            ));
          }
        } else if (area.template == 6) {
          var tmp = blockVod?.vods ?? [];
          _list.add(SizedBox(
            height: kIsWeb ? 215 : 195,
            child: CustomScrollView(
              primary: false,
              physics: const ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_c, _id) {
                      var vod = tmp[_id];
                      return Padding(
                        padding: const EdgeInsets.only(right: 6.0),
                        child: SizedBox(
                          width: (gs().width - 12) / 1.15,
                          child: VBlockItemBig(
                            vod,
                            title: vod.title.toString(),
                          ),
                        ),
                      );
                    },
                    childCount: tmp.length,
                  ),
                ),
              ],
            ),
          ));
          if (showAds && ads.isNotEmpty) {
            ads.shuffle(Random());
            _list.add(VBlockAd(
              bannerId: ads.first.id,
              photoSid: ads.first.photoSid,
              url: ads.first.url,
            ));
          }
        }
        return _list;
      }).reduce((value, element) {
        value.addAll(element);
        return value;
      }).toList();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      padding: const EdgeInsets.only(top: 8),
      child: SmartRefresher(
        enablePullDown: true,
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
        header: CustomHeader(
          builder: (_ctx, RefreshStatus? mode) {
            return SizedBox(
              child: Center(
                child: Column(
                  children: const [
                    VLoading(),
                    Text('載入中...'),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        onLoading: () async {
          _refreshController.requestLoading();
          await Future.delayed(const Duration(seconds: 1));
          setState(() {});
          _refreshController.loadNoData();
        },
        onRefresh: () async {
          // _refreshController.requestLoading();
          await _homeController.fetchArea(channel: widget.channel);
          updateVodList();
          // updateKeepAlive();
          _refreshController.refreshCompleted();
        },
        controller: _refreshController,
        child: CustomScrollView(
          primary: true,
          cacheExtent: gs().height,
          // controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            ...widget.channel.isBanner == true
                ? [
                    SliverToBoxAdapter(
                      child: VDAdsSlider(banners == null ||
                              banners?.channelBanners == null ||
                              banners?.channelBanners.isEmpty == true
                          ? [
                              // VAdItem(
                              //     '${AppController.cc.endpoint.getPhotoSidPreviewPrefix()}202668a5-d651-40a6-846f-bc9978bb183a'),
                              // VAdItem(
                              //     '${AppController.cc.endpoint.getPhotoSidPreviewPrefix()}202668a5-d651-40a6-846f-bc9978bb183a'),
                              // VAdItem(
                              //     '${AppController.cc.endpoint.getPhotoSidPreviewPrefix()}202668a5-d651-40a6-846f-bc9978bb183a'),
                            ]
                          : banners?.channelBanners
                                  .map(
                                    (e) => VAdItem(
                                      // '${AppController.cc.endpoint.getPhotoSidPreviewPrefix()}${e.photoSid}',
                                      e.photoSid,
                                      url: e.url,
                                      id: e.id,
                                    ),
                                  )
                                  .toList() ??
                              []),
                    )
                  ]
                : [],
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: VDJingangs(
                  jingangs:
                      _homeController.cachedJingangs[widget.channel] ?? [],
                  hasFrame: widget.channel.outerFrame ?? false,
                  title: widget.channel.title ?? '',
                  jingangStyle: widget.channel.jingangStyle,
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (_c, _id) {
                  var _widget = vodList[_id];
                  return Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      left: 6,
                      right: 6,
                    ),
                    child: _widget,
                  );
                },
                childCount: vodList.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
