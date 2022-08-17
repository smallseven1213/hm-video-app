import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wgp_video_h5app/base/index.dart';
import 'package:wgp_video_h5app/components/index.dart';
import 'package:wgp_video_h5app/controllers/index.dart';
import 'package:wgp_video_h5app/pages/home.dart';
import 'package:wgp_video_h5app/pages/layout_page.dart';
import 'package:wgp_video_h5app/pages/member_ads_page.dart';
import 'package:wgp_video_h5app/pages/member_page.dart';
import 'package:wgp_video_h5app/pages/member_vip_page.dart';
import 'package:wgp_video_h5app/pages/story_page.dart';

class Default extends StatefulWidget {
  const Default({Key? key}) : super(key: key);

  @override
  _DefaultState createState() => _DefaultState();
}

class _DefaultState extends State<Default> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
      vsync: this,
      initialIndex: 0,
      animationDuration: Duration.zero,
      length: Get.find<VBaseMenuCollection>().getItems().length,
    );
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: TabBarView(
          controller: _tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: Get.find<VBaseMenuCollection>()
              .getItems()
              .map((key, value) {
                if (value.uri == "/home") {
                  return MapEntry(key, const HomePage(title: ''));
                }
                if (value.uri.startsWith('/layout')) {
                  var layoutId = int.parse(value.uri.replaceFirstMapped(
                      RegExp(r"/layout/(\d+)"),
                      (match) => match.group(1).toString()));
                  return MapEntry(
                      key,
                      LayoutPage(
                        layoutId: layoutId,
                      ));
                }

                if (value.uri == '/member/vip2') {
                  return MapEntry(key, const MemberVipPage(refer: 'home'));
                }
                if (value.uri == '/member/vip2') {
                  return MapEntry(key, const MemberVipPage(refer: 'home'));
                }
                if (value.uri == '/member/ads') {
                  return MapEntry(key, const MemberAdsPage(refer: 'home'));
                }
                if (value.uri == '/member') {
                  return MapEntry(key, const MemberPage());
                }

                if (value.uri == '/story') {
                  return MapEntry(key, const StoryPage());
                }
                return MapEntry(key, const SizedBox.shrink());
              })
              .values
              .toList(),
        ),
        bottomNavigationBar: VDBottomNavigationBar(
          collection: Get.find<VBaseMenuCollection>(),
          activeIndex: Get.find<AppController>().navigationBarIndex,
          onTap: (name, index) {
            _tabController.animateTo(index);
          },
        ),
      ),
      onWillPop: () async => false,
    );
  }
}
