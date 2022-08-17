import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wgp_video_h5app/base/index.dart';
import 'package:wgp_video_h5app/components/image/index.dart';
import 'package:wgp_video_h5app/components/index.dart';
import 'package:wgp_video_h5app/components/physics/tab_bar_scroll_physics.dart';
import 'package:wgp_video_h5app/controllers/index.dart';
import 'package:wgp_video_h5app/helpers/getx.dart';
import 'package:wgp_video_h5app/providers/index.dart';
import 'package:wgp_video_h5app/styles.dart';

import '../models/banners.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final int layoutId = 1;
  final _logger = Logger('MyHomeLogger');
  late TabController _tabController;
  final VChannelController _channelController = Get.find<VChannelController>();
  int _currentIndex = 0;
  late Image noticeHeader;
  final HomeController _homeController = Get.find<HomeController>();
  final PageStorageBucket _bucket = PageStorageBucket();

  @override
  void initState() {
    // if (!kIsWeb) {
    //   //   await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
    //   //       overlays: []);
    //   SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    // }
    noticeHeader = Image.asset('assets/img/rectangle@3x.png');
    _channelController
        .setChannels(_homeController.cachedChannels[layoutId] ?? []);

    _tabController = TabController(
      vsync: this,
      initialIndex: _currentIndex,
      length: _channelController.getTabs().length,
    )..addListener(_handleTabChanged);

    super.initState();
    AppController appController = Get.find<AppController>();
    Get.find<NoticeProvider>().getMarquee().then((marqueeList) {
      Get.find<VNoticeController>().setMarquee(marqueeList ?? []);
      setState(() {});
    });
    if (appController.isShowNotice == false) {
      Future.delayed(const Duration(milliseconds: 666)).then((value) {
        _showNotice();
        appController.showNotice();
      });
    }
    var v = '${AppController.cc.version}${kIsWeb ? '' : '_a'}';
    Get.find<UserProvider>().addUserEventRecord(v);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(noticeHeader.image, context);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _showNotice() async {
    var notice = await Get.find<NoticeProvider>().getBounceOne();
    // print(notice);
    if (notice == null) {
      return;
    }
    return showDialog(
        context: context,
        builder: (_ctx) {
          return AlertDialog(
              backgroundColor: Colors.transparent,
              titlePadding: EdgeInsets.zero,
              title: null,
              contentPadding: EdgeInsets.zero,
              content: IntrinsicHeight(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Image.asset('assets/img/rectangle@3x.png'),
                          Positioned(
                            // alignment: Alignment.topRight,
                            right: 15,
                            top: 15,
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: const VDIcon(VIcons.close),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                            left: 20,
                            right: 20,
                            bottom: 0,
                          ),
                          child: Text(
                            notice.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 5,
                          left: 20,
                          right: 20,
                          bottom: 0,
                        ),
                        child: SizedBox(
                          height: gs().height / 5.5,
                          child: SingleChildScrollView(
                            physics: const ClampingScrollPhysics(),
                            child: HtmlWidget(
                              notice.content ?? '',
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 5,
                          left: 20,
                          right: 20,
                          bottom: 15,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            notice.leftButton == null
                                ? const SizedBox.shrink()
                                : Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        if (notice.leftButtonUrl == null ||
                                            notice.leftButtonUrl == '-1') {
                                          Navigator.of(context).pop();
                                        } else {
                                          if (notice.leftButtonUrl
                                                  ?.startsWith('http') ==
                                              true) {
                                            launch(notice.leftButtonUrl
                                                .toString());
                                            Navigator.of(context).pop();
                                            return;
                                          }
                                          gto(notice.leftButtonUrl ?? '/404');
                                        }
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.only(
                                            top: 10, bottom: 10),
                                        margin: const EdgeInsets.only(right: 5),
                                        decoration: BoxDecoration(
                                          color: color6,
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                        child: Text(
                                          notice.leftButton ?? '我知道了',
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  if (notice.rightButtonUrl == null ||
                                      notice.rightButtonUrl == '-1') {
                                    Navigator.of(context).pop();
                                  } else {
                                    if (notice.rightButtonUrl
                                            ?.startsWith('http') ==
                                        true) {
                                      launch(notice.rightButtonUrl.toString());
                                      Navigator.of(context).pop();
                                      return;
                                    }
                                    gto(notice.rightButtonUrl ?? '/404');
                                  }
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10),
                                  margin: const EdgeInsets.only(left: 5),
                                  decoration: BoxDecoration(
                                    color: color1,
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: Text(
                                    notice.rightButton ?? '我知道了',
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ));
        }).then((value) {
      List<BannerPhoto> banners= Get.find<VAdController>().positionBanners[5]!;
      _showAd(banners, 0);
    });
  }

  Future<void> _showAd(List<BannerPhoto> banners, int index) async {
    if (banners == null || banners.isEmpty || banners.length < index) {
      return;
    }
    BannerPhoto banner = banners[index];
    // print(banners.first.photoSid);
    return showDialog(
        context: context,
        builder: (_ctx) {
          return AlertDialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            titlePadding: EdgeInsets.zero,
            title: null,
            contentPadding: EdgeInsets.zero,
            content: SizedBox(
              width: gs().width,
              // height: gs().height * .5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.find<AdProvider>().clickedBanner(banner.id);
                      if (banner.url != null) {
                        launch(banner.url.toString());
                      }
                    },
                    child: AspectRatio(
                      aspectRatio: 9 / 12,
                      child: VDImage(
                        // "${AppController.cc.endpoint.getPhotoSidPreviewPrefix()}${banners.first.photoSid}",
                        url: banner.photoSid,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (banners.length > index+1) {
                            Navigator.of(context).pop();
                            _showAd(banners, (1 + index));
                          } else {
                            Navigator.of(context).pop();
                          }
                        },
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 1),
                            borderRadius: BorderRadius.circular(36.0),
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
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
        .setChannels(_homeController.cachedChannels[layoutId] ?? []);

    // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    //   statusBarColor: Colors.transparent,
    //   systemNavigationBarColor: Colors.transparent,
    // ));
    var _marqueeText = Get.find<VNoticeController>()
        .getMarquee()
        .values
        .map((e) => e.title)
        .join('    ');
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
              toolbarHeight: 142,
              collapsedHeight: 142,
              expandedHeight: 142,
              pinned: true,
              backgroundColor: color1,
              flexibleSpace: FlexibleSpaceBar(
                background: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: color1,
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: gs().width - (gs().width / 5),
                            height: 64,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 15,
                                bottom: 15,
                                left: 15,
                                right: 15,
                              ),
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
                                  contentPadding:
                                      const EdgeInsets.only(left: 16),
                                  suffixIcon: const VDIcon(VIcons.search),
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
                          InkWell(
                            onTap: () {
                              gto('/member/record/history');
                            },
                            child: const VDIcon(VIcons.history),
                          ),
                          SizedBox(width: (gs().width / 26)),
                          InkWell(
                            onTap: () {
                              gto('/filter');
                            },
                            child: const VDIcon(VIcons.filter),
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
                        showExtra: true,
                        layoutId: 1,
                        onOpenCustomChannels: () {
                          gto('/channel-settings/1')?.then((v) {
                            setState(() {});
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          gto('/member/messages');
                        },
                        child: Container(
                          padding: const EdgeInsets.only(left: 10),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          child: VDMarquee(
                            width: gs().width - 20,
                            text: _marqueeText,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: true,
              child: TabBarView(
                controller: _tabController,
                // physics: const AlwaysScrollableScrollPhysics(),
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
