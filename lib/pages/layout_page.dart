import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:wgp_video_h5app/base/v_icon_collection.dart';
import 'package:wgp_video_h5app/components/index.dart';
import 'package:wgp_video_h5app/components/physics/tab_bar_scroll_physics.dart';
import 'package:wgp_video_h5app/components/v_d_icon.dart';
import 'package:wgp_video_h5app/components/v_d_sticky_tab_bar.dart';
import 'package:wgp_video_h5app/controllers/index.dart';
import 'package:wgp_video_h5app/controllers/v_channel_controller.dart';
import 'package:wgp_video_h5app/helpers/getx.dart';
import 'package:wgp_video_h5app/providers/index.dart';
import 'package:wgp_video_h5app/styles.dart';

class LayoutPage extends StatefulWidget {
  final int? layoutId;
  const LayoutPage({Key? key, this.layoutId}) : super(key: key);

  @override
  State<LayoutPage> createState() => _LayoutPageState();
}

class _LayoutPageState extends State<LayoutPage> with TickerProviderStateMixin {
  final _logger = Logger('LayoutPageLogger');
  late TabController _tabController;
  final VChannelController _channelController = Get.find<VChannelController>();
  int _currentIndex = 0;
  int _layoutId = 0;
  final HomeController _homeController = Get.find<HomeController>();

  @override
  void initState() {
    _layoutId =
        widget.layoutId ?? int.parse(Get.parameters['layoutId'] as String);
    _channelController.setChannels(
      _homeController.cachedChannels[_layoutId] ?? [],
      persistent: false,
    );
    _tabController = TabController(
      vsync: this,
      initialIndex: _currentIndex,
      length: _channelController.getTabs().length,
    )..addListener(_handleTabChanged);
    super.initState();
    Get.find<NoticeProvider>().getMarquee().then((marqueeList) =>
        Get.find<VNoticeController>().setMarquee(marqueeList ?? []));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChanged() {
    setState(() {
      _currentIndex = _tabController.index;
      _channelController.setCurrentChannel(_currentIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    _channelController
        .setChannels(_homeController.cachedChannels[_layoutId] ?? []);
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: mainBgColor,
          shadowColor: Colors.transparent,
          toolbarHeight: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: mainBgColor,
          ),
        ),
        body: CustomScrollView(
          primary: false,
          physics: const NeverScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              toolbarHeight: 112,
              collapsedHeight: 112,
              expandedHeight: 112,
              pinned: true,
              flexibleSpace: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: mainBgColor,
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: gs().width,
                          height: 64,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 15, bottom: 15, left: 15, right: 15),
                            child: TextFormField(
                              onTap: () {
                                gto('/search');
                              },
                              readOnly: true,
                              style: const TextStyle(
                                  // backgroundColor: Colors.white,
                                  ),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.only(left: 16),
                                suffixIcon: VDIcon(VIcons.search),
                                suffixIconColor:
                                    const Color.fromRGBO(167, 167, 167, 1),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none,
                                ),
                                // hintText: '輸入番號、女優名或...',
                                hintText: '搜尋...',
                                hintStyle: const TextStyle(
                                  fontSize: 14,
                                  color: Color.fromRGBO(167, 167, 167, 1),
                                ),
                                focusColor: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: color1,
                    ),
                    child: VDStickyTabBar(
                      tabController: _tabController,
                      currentIndex: _currentIndex,
                      controller: _channelController,
                      showExtra: false,
                      layoutId: _layoutId,
                      tabBarType: 1,
                      onOpenCustomChannels: () {
                        // gto('/channel-settings/$_layoutId')?.then((v) {
                        //   setState(() {});
                        // });
                      },
                    ),
                  ),
                ],
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: true,
              child: TabBarView(
                controller: _tabController,
                physics: const TabBarScrollPhysics(),
                children: _channelController.channels.map(
                  (value) {
                    return VDChannelBodyView(
                      channel: value,
                      currentIndex: _currentIndex,
                    );
                  },
                ).toList(),
              ),
            ),
          ],
        ),
        // bottomNavigationBar: VDBottomNavigationBar(
        //   collection: Get.find<VBaseMenuCollection>(),
        //   activeIndex: Get.find<AppController>().navigationBarIndex,
        //   onTap: Get.find<AppController>().toNamed,
        // ),
      ),
    );
  }
}
