import 'package:app_gs/screens/main_screen/channel_style_3/tags.dart';
import 'package:app_gs/screens/main_screen/channel_style_3/vods.dart';
import 'package:app_gs/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/channel_shared_data_controller.dart';

import '../../../widgets/channel_jingang_area.dart';
import '../../../widgets/tab_bar.dart';

final logger = Logger();

Widget buildTitle(String title) {
  return title == ''
      ? const SizedBox()
      : Column(
          children: [
            const SizedBox(height: 8),
            Header(text: title),
          ],
        );
}

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
    var tags = (channelSharedDataController?.channelSharedData.value?.blocks
            ?.map((e) => e.id.toString())
            .toList()) ??
        [];
    _tabController = TabController(length: tags.length, vsync: this);
    if (channelSharedDataController?.channelSharedData != null) {
      ever(channelSharedDataController!.channelSharedData!,
          (channelSharedData) {
        _tabController!.dispose();
        var newLength = channelSharedData?.blocks?.length ?? 0;
        _tabController = TabController(length: newLength, vsync: this);
        setState(() {});
      });
    }

    // if tab change , reset scroll top
    _tabController!.addListener(() {
      _parentScrollController.jumpTo(0);
    });
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
        controller: PrimaryScrollController.of(context),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverToBoxAdapter(
                child: buildTitle(channelSharedDataController!
                        .channelSharedData.value?.jingang!.title ??
                    '')),
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
                              tabs: (channelSharedDataController
                                      ?.channelSharedData.value?.blocks
                                      ?.map((e) =>
                                          e.name != null && e.name!.length > 8
                                              ? e.name!.substring(0, 8)
                                              : e.name ?? '')
                                      .toList()) ??
                                  [],
                            )),
                      ),
                    )),
              ),
            ),
          ];
        },
        body: Obx(() => TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _tabController,
              children:
                  channelSharedDataController!.channelSharedData.value?.blocks
                          ?.map((e) => Vods(
                                areaId: e.id ?? 0,
                                templateId: e.template,
                              ))
                          .toList() ??
                      [],
            )),
      ),
    );
  }
}
