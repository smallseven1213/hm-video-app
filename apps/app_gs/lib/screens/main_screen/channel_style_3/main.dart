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
  final GlobalKey targetKey = GlobalKey();
  TabController? _tabController;
  late ChannelSharedDataController? channelSharedDataController;
  final ScrollController _scrollController = ScrollController();

  void _setupTabController() {
    _tabController?.dispose();
    var tags = (channelSharedDataController?.channelSharedData.value?.blocks
            ?.map((e) => e.id.toString())
            .toList()) ??
        [];
    _tabController = TabController(length: tags.length, vsync: this);

    _tabController?.addListener(() {
      if (_tabController!.indexIsChanging) {
        // RenderBox? box =
        //     targetKey.currentContext?.findRenderObject() as RenderBox?;
        // Offset? position = box?.localToGlobal(Offset.zero);
        // _scrollController.animateTo(
        //   position?.dy ?? 0.0,
        //   duration: const Duration(milliseconds: 200),
        //   curve: Curves.easeInOut,
        // );
        Scrollable.ensureVisible(
          targetKey.currentContext!,
          duration: const Duration(milliseconds: 200),
          curve: Curves.ease,
        );
      }
    });
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
        setState(() {});
      });
    }

    logger.i('tabController before');
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
        controller: _scrollController,
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
            SliverToBoxAdapter(key: targetKey),
            SliverAppBar(
              pinned: true,
              leading: null,
              automaticallyImplyLeading: false,
              forceElevated: true,
              expandedHeight: 0,
              toolbarHeight: 0,
              flexibleSpace: const SizedBox.shrink(),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: SizedBox(
                    height: 50,
                    child: SizedBox(
                      height: 50,
                      child: SizedBox(
                        height: 50,
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
                          ?.asMap()
                          .entries
                          .map((e) => Vods(
                                key: Key('${e.key}'),
                                areaId: e.value.id ?? 0,
                                templateId: e.value.template,
                                isActive: e.key == _tabController!.index,
                              ))
                          .toList() ??
                      [],
            )),
      ),
    );
  }
}
