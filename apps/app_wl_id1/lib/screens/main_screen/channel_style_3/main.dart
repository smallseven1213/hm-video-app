import 'package:app_wl_id1/screens/main_screen/channel_style_3/tags.dart';
import 'package:app_wl_id1/screens/main_screen/channel_style_3/vods.dart';
import 'package:app_wl_id1/widgets/reload_button.dart';
import 'package:app_wl_id1/widgets/wave_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/channel_shared_data_controller.dart';

import '../../../widgets/channel_banners.dart';
import '../../../widgets/channel_jingang_area.dart';
import '../../../widgets/channel_jingang_area_title.dart';
import '../../../widgets/tab_bar.dart';
import 'posts.dart';

final logger = Logger();

class ChannelStyle3Main extends StatefulWidget {
  final int channelId;

  const ChannelStyle3Main({Key? key, required this.channelId})
      : super(key: key);

  @override
  ChannelStyle3MainState createState() => ChannelStyle3MainState();
}

class ChannelStyle3MainState extends State<ChannelStyle3Main>
    with TickerProviderStateMixin {
  final GlobalKey targetKey = GlobalKey();
  TabController? _tabController;
  late ChannelSharedDataController? channelSharedDataController;
  final ScrollController _scrollController = ScrollController();

  void _setupTabController() {
    if (mounted) {
      if (_tabController != null) {
        _tabController?.dispose();
        _tabController = null;
      }

      var tags = (channelSharedDataController?.channelSharedData.value?.blocks
              ?.map((e) => e.id.toString())
              .toList()) ??
          [];
      _tabController = TabController(length: tags.length, vsync: this);

      _tabController?.addListener(() {
        if (_tabController!.indexIsChanging) {
          if (targetKey.currentContext != null) {
            Scrollable.ensureVisible(
              targetKey.currentContext!,
              duration: const Duration(milliseconds: 200),
              curve: Curves.ease,
            );
          }
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    channelSharedDataController = Get.find<ChannelSharedDataController>(
      tag: '${widget.channelId}',
    );

    _setupTabController();

    if (channelSharedDataController?.channelSharedData != null) {
      ever(channelSharedDataController!.channelSharedData, (channelSharedData) {
        _setupTabController();
        if (mounted) {
          setState(() {});
        }
      });
    }

    logger.i('tabController before');
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final channelSharedData =
            channelSharedDataController!.channelSharedData.value;
        if (channelSharedDataController!.isLoading.value) {
          return const Center(
            child: WaveLoading(),
          );
        } else if (channelSharedDataController!.isError.value) {
          return Center(
            child: ReloadButton(
              onPressed: () {
                channelSharedDataController!
                    .mutateByChannelId(widget.channelId);
                _setupTabController();
              },
            ),
          );
        }
        return NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              ChannelBanners(
                channelId: widget.channelId,
              ),
              ChannelJingangAreaTitle(
                channelId: widget.channelId,
              ),
              ChannelJingangArea(
                channelId: widget.channelId,
              ),
              ChannelTags(
                channelId: widget.channelId,
              ),
              if (_tabController!.length > 1) ...[
                const SliverToBoxAdapter(
                  child: SizedBox(height: 8),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverAppBarDelegate(
                    preferredHeight: 50,
                    bottom: GSTabBar(
                      controller: _tabController,
                      padding: const EdgeInsets.all(0),
                      tabs: (channelSharedData?.blocks
                              ?.map((e) => e.name != null && e.name!.length > 8
                                  ? e.name!.substring(0, 8)
                                  : e.name ?? '')
                              .toList()) ??
                          [],
                    ),
                  ),
                ),
              ]
            ];
          },
          body: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: channelSharedData?.blocks
                    ?.asMap()
                    .entries
                    .map((e) => e.value.film == 4
                        ? Posts(
                            key: Key('${widget.channelId}'),
                            postId: widget.channelId,
                            areaId: e.value.id ?? 0,
                            isActive: e.key == _tabController!.index,
                            isAreaAds: e.value.isAreaAds!,
                          )
                        : Vods(
                          key: Key('${e.key}'),
                          areaId: e.value.id ?? 0,
                          templateId: e.value.template,
                          isActive: e.key == _tabController!.index,
                          gameBlocks: channelSharedData.gameBlocks,
                        ))
                    .toList() ??
                [],
          ),
        );
      }),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double preferredHeight;
  final Widget bottom;

  _SliverAppBarDelegate({required this.preferredHeight, required this.bottom});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white, // 根据需要设置背景色
      child: bottom,
    );
  }

  @override
  double get maxExtent => preferredHeight;

  @override
  double get minExtent => preferredHeight;

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return bottom != oldDelegate.bottom;
  }
}
