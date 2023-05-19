// ChannelStyle3Main is a statefull widget

import 'package:app_gs/screens/main_screen/channel_style_3/tags.dart';
import 'package:app_gs/screens/main_screen/channel_style_3/vods.dart';
import 'package:app_gs/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/channel_shared_data_controller.dart';

import '../../../widgets/channel_banners.dart';
import '../../../widgets/channel_jingang_area.dart';
import '../../../widgets/tab_bar.dart';

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
  TabController? _tabController;
  final ScrollController _parentScrollController = ScrollController();
  late ChannelSharedDataController? channelSharedDataController;

  @override
  void initState() {
    super.initState();
    channelSharedDataController = Get.find<ChannelSharedDataController>(
      tag: '${widget.channelId}',
    );
    var tags = channelSharedDataController!.channelSharedData.value?.blocks
            ?.map((e) => e.id.toString())
            .toList() ??
        [];
    _tabController = TabController(length: tags.length, vsync: this);
    ever(channelSharedDataController!.channelSharedData, (_) {
      _tabController!.dispose();
      _tabController = TabController(length: _!.blocks!.length, vsync: this);
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    logger.i('DISPOSE!!!');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: _parentScrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ChannelBanners(
                  channelId: widget.channelId,
                ),
              ),
            ),
            ChannelJingangArea(
              channelId: widget.channelId,
            ),
            ChannelTags(
              channelId: widget.channelId,
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
                preferredSize: const Size.fromHeight(60),
                child: SizedBox(
                    height: 60,
                    child: SizedBox(
                      height: 60,
                      child: SizedBox(
                        height: 60,
                        child: Obx(() => GSTabBar(
                              controller: _tabController,
                              tabs: channelSharedDataController
                                      ?.channelSharedData.value?.blocks
                                      ?.map((e) => e.name ?? '')
                                      .toList() ??
                                  [],
                            )),
                      ),
                    )),
              ),
            ),
          ];
        },
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _tabController,
          // Obx and return channelSharedDataController!.channelSharedData.blocks get id
          children: channelSharedDataController!.channelSharedData.value?.blocks
                  ?.map((e) => Vods(
                        scrollController: _parentScrollController,
                        areaId: e.id ?? 0,
                        templateId: e.template,
                      ))
                  .toList() ??
              [],
        ),
      ),
    );
  }
}
