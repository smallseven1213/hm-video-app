import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:video_player/video_player.dart';
import 'package:wgp_video_h5app/base/v_icon_collection.dart';
import 'package:wgp_video_h5app/base/v_menu_collection.dart';
import 'package:wgp_video_h5app/components/index.dart';
import 'package:wgp_video_h5app/components/v_d_bottom_navigation_bar.dart';
import 'package:wgp_video_h5app/components/v_d_icon.dart';
import 'package:wgp_video_h5app/controllers/app_controller.dart';
import 'package:wgp_video_h5app/controllers/index.dart';
import 'package:wgp_video_h5app/helpers/getx.dart';
import 'package:wgp_video_h5app/models/index.dart';
import 'package:wgp_video_h5app/models/story_video_view.dart';
import 'package:wgp_video_h5app/pages/story_search.dart';
import 'package:wgp_video_h5app/providers/index.dart';
import 'package:wgp_video_h5app/styles.dart';

import '../base/v_ads_collection.dart';
import '../components/v_d_sticky_tab_bar_delegate1.dart';
import '../configs/c_menu_bar_dark.dart';
import '../models/blocks.dart';
import '../models/channels.dart';
import '../models/jingangs.dart';
import '../models/short_video_detail.dart';
import '../models/supplier.dart';
import '../models/video.dart';
import '../models/videos_tag.dart';
import '../models/videos_view.dart';

class StoryVideoPage extends StatefulWidget {
  const StoryVideoPage({Key? key, required this.videos, required this.title}) : super(key: key);

  final List<Video> videos;
  final String title;

  @override
  State<StoryVideoPage> createState() => _StoryVideoPageState();
}

class _StoryVideoPageState extends State<StoryVideoPage>
    with TickerProviderStateMixin {
  final _logger = Logger('StoryPageLogger');
  late TabController _tabController;
  int _currentIndex = 0;
  final HomeController _homeController = Get.find<HomeController>();
  ScrollController _scrollController = ScrollController();
  late final VideosStoryView recommendsSource;

  bool loading = false;
  int upPages = 0;
  int limit = 10;
  int currentLoad = 0;
  int upTotal = 0;
  List<Widget> suppliers = [];
  List<Widget> tabs = [];
  List<Widget> tabsData = [];
  bool isPlay = false;
  bool errorVideo = false;
  bool loadVideo = false;
  User? user;
  bool isInitialized = false;
  late PageController recommendPageController;
  int recommendActualScreen = 0;

  @override
  void initState() {
    recommendsSource = VideosStoryView(widget.videos);
    recommendPageController = PageController(
      initialPage: recommendActualScreen,
      viewportFraction: 1,
    );
    super.initState();
    Get.find<UserProvider>().getCurrentUser().then((value) => {user = value});
    tabs.add(Tab(
      text: widget.title,
    ));

    _tabController = TabController(
      vsync: this,
      initialIndex: _currentIndex,
      length: tabs.length,
    );

    _tabController.addListener(_handleTabChanged);
    // loadUp();
  }

  @override
  void dispose() {
    _tabController.dispose();
    recommendsSource.videoSource!.listVideos.forEach((element) {
      if (element.controller != null) {
        element.controller!.dispose();
      }
    });
    recommendsSource.videoSource!.listVideos.clear();
    suppliers.clear();
    upPages = 0;
    currentLoad = 0;
    upTotal = 0;
    limit = 0;
    super.dispose();
  }

  void _handleTabChanged() {
    // getSource().pauseCurrent();

    setState(() {
      _currentIndex = _tabController.index;
    });

    pauseAll();
    if (recommendPageController.hasClients) {
      recommendPageController.jumpToPage(recommendActualScreen);
      recommendsSource.changeVideo(recommendActualScreen);
      setState(() {
        isPlay = false;
      });
    }
  }

  bool isRecommendsPage() => _tabController.index == tabs.length - 1;

  bool isFollowsPage() => _tabController.index == tabs.length - 2;

  void pauseAll() {
    isPlay = true;
    recommendsSource.pauseCurrent();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    toolbarHeight: 0,
                    pinned: true,
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: VDStickyTabBarDelegate1(
                      backgroundColor: Colors.black,
                      child: TabBar(
                          isScrollable: true,
                          indicatorColor: Colors.black,
                          controller: _tabController,
                          // give the indicator a decoration (color and border radius)
                          indicator: BoxDecoration(
                            color: Colors.black,
                          ),
                          labelColor: Colors.white,
                          labelStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          unselectedLabelStyle: TextStyle(
                            fontSize: 14,
                          ),
                          unselectedLabelColor: Color(0xFF979797),
                          tabs: tabs),
                      iconLeft: InkWell(
                        onTap: () => {
                          pauseAll(),
                          setState(() {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                // builder methods always take context!
                                builder: (context) {
                                  return StorySearchPage();
                                },
                              ),
                            );
                          }),
                        },
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          enableFeedback: true,
                          child: VDIcon(
                            VIcons.back,
                            height: 22,
                            width: 22,
                          ),
                        ),
                      ),
                    ),
                  ),
                ];
              },
              body: TabBarView(controller: _tabController,
                  // physics: const NeverScrollableScrollPhysics(),
                  children: [
                    videoTab(recommendsSource, recommendPageController)
                  ]),
            )
          ],
        ),
//        bottomNavigationBar: VDBottomNavigationBar(
//          collection: _currentIndex == tabs.length - 1 ||
//                  _currentIndex == tabs.length - 2
//              ? CMenuBarDark()
//              : Get.find<VBaseMenuCollection>(),
//          activeIndex: Get.find<AppController>().navigationBarIndex,
//          onTap: Get.find<AppController>().toNamed,
//        ),
      ),
    );
  }

  Column block1Card(Channel channel, Block block1) {
    bool showBlock1 = block1 != null;
    List<Vod> block1Vods =
        showBlock1 && _homeController.cachedBlockVods[block1.id] != null
            ? _homeController.cachedBlockVods[block1.id]!.vods.isNotEmpty
                ? _homeController.cachedBlockVods[block1.id]!.vods
                : []
            : [];
    List<Widget> leftw = [
      const SizedBox(
        width: 8,
      )
    ];
    return Column(
      children: [
        showBlock1
            ? Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                SizedBox(
                  width: 20,
                ),
                Text(
                  block1.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ])
            : Container(),
        showBlock1
            ? Container(
                height: 140,
                padding: const EdgeInsets.only(
                  left: 0,
                  right: 8,
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(
                      scrollbarTheme: ScrollbarThemeData(
                    thumbColor: MaterialStateProperty.all(mainBgColor),
                    trackColor: MaterialStateProperty.all(
                        const Color.fromRGBO(238, 238, 238, 1)),
                    trackBorderColor:
                        MaterialStateProperty.all(Colors.transparent),
                    trackVisibility: MaterialStateProperty.all(true),
                    mainAxisMargin: 150,
                    minThumbLength: 1,
                    radius: const Radius.circular(60),
                    thickness: MaterialStateProperty.all(4),
                    // isAlwaysShown: true,
                  )),
                  child: Scrollbar(
                      controller: _scrollController,
                      child: ListView(
                          controller: _scrollController,
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          children: leftw +
                              block1Vods
                                  .map((e) => buildCard2(e, block1))
                                  .toList() +
                              [buildCard1(block1Vods[0], block1)])),
                ),
              )
            : Container(),
      ],
    );
  }

  Column block2Card(Channel channel, Block block2) {
    bool showBlock2 = block2 != null;
    List<Vod> block2Vods =
        showBlock2 && _homeController.cachedBlockVods[block2.id] != null
            ? _homeController.cachedBlockVods[block2.id]!.vods.isNotEmpty
                ? _homeController.cachedBlockVods[block2.id]!.vods
                : []
            : [];

    return Column(
      children: [
        showBlock2
            ? Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                SizedBox(
                  width: 20,
                ),
                Text(
                  block2.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ])
            : Container(),
        showBlock2
            ? Container(
                padding: const EdgeInsets.only(
                  left: 8,
                  right: 8,
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(
                      scrollbarTheme: ScrollbarThemeData(
                    thumbColor: MaterialStateProperty.all(mainBgColor),
                    trackColor: MaterialStateProperty.all(
                        const Color.fromRGBO(238, 238, 238, 1)),
                    trackBorderColor:
                        MaterialStateProperty.all(Colors.transparent),
                    trackVisibility: MaterialStateProperty.all(true),
                    mainAxisMargin: 150,
                    minThumbLength: 1,
                    radius: const Radius.circular(60),
                    thickness: MaterialStateProperty.all(4),
                    // isAlwaysShown: true,
                  )),
                  child: Column(children: buildArea2Vods(block2Vods, block2)),
                ),
              )
            : Container(),
      ],
    );
  }

  Column block3Card(Channel channel, Block block3) {
    bool showBlock2 = block3 != null;
    List<Vod> block2Vods =
        showBlock2 && _homeController.cachedBlockVods[block3.id] != null
            ? _homeController.cachedBlockVods[block3.id]!.vods.isNotEmpty
                ? _homeController.cachedBlockVods[block3.id]!.vods
                : []
            : [];

    return Column(
      children: [
        showBlock2
            ? Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                SizedBox(
                  width: 20,
                ),
                Text(
                  block3.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ])
            : Container(),
        showBlock2
            ? Container(
                padding: const EdgeInsets.only(
                  left: 8,
                  right: 8,
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(
                      scrollbarTheme: ScrollbarThemeData(
                    thumbColor: MaterialStateProperty.all(mainBgColor),
                    trackColor: MaterialStateProperty.all(
                        const Color.fromRGBO(238, 238, 238, 1)),
                    trackBorderColor:
                        MaterialStateProperty.all(Colors.transparent),
                    trackVisibility: MaterialStateProperty.all(true),
                    mainAxisMargin: 150,
                    minThumbLength: 1,
                    radius: const Radius.circular(60),
                    thickness: MaterialStateProperty.all(4),
                    // isAlwaysShown: true,
                  )),
                  child: Column(children: buildArea3Vods(block2Vods, block3)),
                ),
              )
            : Container(),
      ],
    );
  }

  Widget channelTab(Channel channel) {
    bool showbanner = _homeController
            .cachedChannelBanners[channel]?.channelBanners.isNotEmpty ??
        false;
    bool showJingangs = _homeController.cachedJingangs[channel] != null;
    List<Column>? blocks1 = _homeController.cachedBlocks[channel]
        ?.where((element) => element.template == 8)
        .map((block) {
      return block1Card(channel, block);
    }).toList();

    List<Column>? blocks2 = _homeController.cachedBlocks[channel]
        ?.where((element) => element.template == 9)
        .map((block) {
      return block2Card(channel, block);
    }).toList();

    List<Column>? blocks3 = _homeController.cachedBlocks[channel]
        ?.where((element) => element.template == 10)
        .map((block) {
      return block3Card(channel, block);
    }).toList();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Material(
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            showbanner
                ? VDAdsSlider(_homeController
                        .cachedChannelBanners[channel]?.channelBanners
                        .map(
                          (e) => VAdItem(
                            // '${AppController.cc.endpoint.getPhotoSidPreviewPrefix()}${e.photoSid}',
                            e.photoSid,
                            url: e.url,
                            id: e.id,
                          ),
                        )
                        .toList() ??
                    [])
                : Container()
            //
            // VDAdsSlider(
            //     [
            //               VAdItem(
            //                   'e0f57dde-c299-4489-9c27-dd7f61a4fcd4'),
            //       VAdItem(
            //           'e0f57dde-c299-4489-9c27-dd7f61a4fcd4'),
            //       VAdItem(
            //           'e0f57dde-c299-4489-9c27-dd7f61a4fcd4'),
            //     ]
            //
            // )
            ,
            SizedBox(
              height: 12,
            ),
            showJingangs
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                        SizedBox(
                          width: 16,
                        ),
                        Text(
                          "精選UP主",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ])
                : Container(),
            showJingangs
                ? showJingang(_homeController.cachedJingangs[channel]!)
                : Container(),
            SizedBox(
              height: 16,
            ),
            // Row(
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     children: const [
            //       SizedBox(
            //         width: 16,
            //       ),
            //       Text(
            //         "排行榜單",
            //         style: TextStyle(
            //           fontSize: 18,
            //           fontWeight: FontWeight.w600,
            //         ),
            //       )
            //     ]),
            // Row(
            //   children: [
            //     SizedBox(
            //       width: 16,
            //     ),
            //     ClipRRect(
            //       child: SizedBox(
            //         height: 106,
            //         width: likeWidth,
            //         child: Stack(
            //           children: [
            //             Container(
            //               color: Colors.white,
            //             ),
            //             Align(
            //               alignment: Alignment.bottomCenter,
            //               child: Container(
            //                 decoration: BoxDecoration(
            //                     color: Color(0xFFf2f2f2),
            //                     borderRadius:
            //                         BorderRadius.circular(6.0)),
            //                 height: 68,
            //                 width: likeWidth,
            //               ),
            //             ),
            //             Align(
            //               alignment: Alignment.bottomCenter,
            //               child: Container(
            //                 height: 86,
            //                 width: likeWidth,
            //                 child: Column(
            //                   children: [
            //                     Image.asset(
            //                       'assets/png/1.png',
            //                       width: 46,
            //                       height: 50,
            //                     ),
            //                     SizedBox(
            //                       height: 6,
            //                     ),
            //                     const Text("人氣視頻"),
            //                     SizedBox(
            //                       height: 10,
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ),
            //     SizedBox(
            //       width: 13,
            //     ),
            //     ClipRRect(
            //       child: SizedBox(
            //         height: 106,
            //         width: likeWidth,
            //         child: Stack(
            //           children: [
            //             Container(
            //               color: Colors.white,
            //             ),
            //             Align(
            //               alignment: Alignment.bottomCenter,
            //               child: Container(
            //                 decoration: BoxDecoration(
            //                     color: Color(0xFFf2f2f2),
            //                     borderRadius:
            //                         BorderRadius.circular(6.0)),
            //                 height: 68,
            //                 width: likeWidth,
            //               ),
            //             ),
            //             Align(
            //               alignment: Alignment.bottomCenter,
            //               child: Container(
            //                 height: 86,
            //                 width: likeWidth,
            //                 child: Column(
            //                   children: [
            //                     Image.asset(
            //                       'assets/png/2.png',
            //                       width: 46,
            //                       height: 50,
            //                     ),
            //                     SizedBox(
            //                       height: 6,
            //                     ),
            //                     const Text("最多喜歡"),
            //                     SizedBox(
            //                       height: 10,
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ),
            //     SizedBox(
            //       width: 16,
            //     ),
            //     ClipRRect(
            //       child: SizedBox(
            //         height: 106,
            //         width: likeWidth,
            //         child: Stack(
            //           children: [
            //             Container(
            //               color: Colors.white,
            //             ),
            //             Align(
            //               alignment: Alignment.bottomCenter,
            //               child: Container(
            //                 decoration: BoxDecoration(
            //                     color: Color(0xFFf2f2f2),
            //                     borderRadius:
            //                         BorderRadius.circular(6.0)),
            //                 height: 68,
            //                 width: likeWidth,
            //               ),
            //             ),
            //             Align(
            //               alignment: Alignment.bottomCenter,
            //               child: Container(
            //                 height: 86,
            //                 width: likeWidth,
            //                 child: Column(
            //                   children: [
            //                     Image.asset(
            //                       'assets/png/3.png',
            //                       width: 46,
            //                       height: 50,
            //                     ),
            //                     SizedBox(
            //                       height: 6,
            //                     ),
            //                     const Text("UP熱榜"),
            //                     SizedBox(
            //                       height: 10,
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            // SizedBox(
            //   height: 22,
            // ),
            Column(
              children: blocks1 ?? [],
            ),
            Column(
              children: blocks2 ?? [],
            ),
            Column(
              children: blocks3 ?? [],
            )
          ],
        ),
      ),
    );
  }

  List chunk(List list, int chunkSize) {
    List chunks = [];
    int len = list.length;
    for (var i = 0; i < len; i += chunkSize) {
      int size = i + chunkSize;
      chunks.add(list.sublist(i, size > len ? len : size));
    }
    return chunks;
  }

  Widget videoTab(StoryView source, PageController pageController) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
            child: Stack(
          children: [
            PageView.builder(
              physics: PageScrollPhysics(),
              controller: pageController,
              itemCount: source.videoSource!.listVideos.length,
              onPageChanged: (index) {
                if (source.videoSource!.listVideos.length == 0) {
                  return;
                }
                index = index % (source.videoSource!.listVideos.length);
                source.changeVideo(index);
                isInitialized = false;
                errorVideo = false;
                loadVideo = false;
                isPlay = false;
                setState(() {
                  recommendActualScreen = index;
                });
              },
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                if (source.videoSource!.listVideos.length == 0) {
                  return Container();
                }
                index = index % (source.videoSource!.listVideos.length);
                return videoCard(source.videoSource!.listVideos[index]);
              },
            ),
          ],
        )),
      ],
    );
  }

  List<Widget> buildArea2Vods(List<Vod> data, Block block) {
    return chunk(data, 3).map((element) {
      List e = List.from(element);
      return Column(
        children: [
          Row(
            children: [
              e.length >= 1 ? buildArea2Vod(element[0], block) : Container(),
              SizedBox(
                width: 5,
              ),
              e.length >= 2 ? buildArea2Vod(element[1], block) : Container(),
              SizedBox(
                width: 5,
              ),
              e.length >= 3 ? buildArea2Vod(element[2], block) : Container(),
            ],
          ),
          SizedBox(
            height: 12,
          ),
        ],
      );
    }).toList();
  }

  areaToRecommends(int videoId, int blockId) {
    Get.find<BlockProvider>()
        .getShortVideoPopular(blockId, videoId)
        .then((value) => {
              recommendsSource.changeSource(value),
              _tabController.animateTo(_tabController.length - 1),
              setState(() {
                recommendActualScreen = 0;
              }),
            });
  }

  buildArea2Vod(Vod vod, Block block) {
    return GestureDetector(
        onTap: () => areaToRecommends(vod.id, block.id),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(7.0),
            child: Image.network(
              "${AppController.cc.endpoint.getPhotoSidPreviewPrefix()}${vod.coverVertical!}",
              width: (gs().width - 26) / 3,
              height: ((gs().width - 26) / 3) * 1.31578947368,
              fit: BoxFit.fill,
            )));
  }

  List<Widget> buildArea3Vods(List<Vod> data, Block block) {
    return chunk(data, 2).map((element) {
      List e = List.from(element);
      return Column(
        children: [
          Row(
            children: [
              e.length >= 1 ? buildArea3Vod(element[0], block) : Container(),
              e.length >= 2
                  ? SizedBox(
                      width: 5,
                    )
                  : Container(),
              e.length >= 2 ? buildArea3Vod(element[1], block) : Container(),
            ],
          ),
          SizedBox(
            height: 12,
          ),
        ],
      );
    }).toList();
  }

  buildArea3Vod(Vod vod, Block block) {
    return GestureDetector(
        onTap: () => areaToRecommends(vod.id, block.id),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(7.0),
            child: Image.network(
              "${AppController.cc.endpoint.getPhotoSidPreviewPrefix()}${vod.coverVertical!}",
              width: (gs().width - 21) / 2,
              height: ((gs().width - 21) / 2) * 1.31578947368,
              fit: BoxFit.fill,
            )));
  }

  Widget buildCard(JinGang data) {
    return GestureDetector(
      onTap: () {
        gto('/story/up/${data.id.toString()}');
      },
      child: Column(
        children: [
          Container(
            width: gs().width * 0.16,
            margin: const EdgeInsets.only(
              left: 14,
              top: 8,
              bottom: 0,
            ),
            child: Card(
              elevation: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: color1,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: VDIcon.network(
                        "${AppController.cc.endpoint.getPhotoSidPreviewPrefix()}${data.photoSid}",
                        width: 60,
                        height: 60,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    data.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: gs().width * 0.069,
          ),
        ],
      ),
    );
  }

  Widget buildCard1(Vod vod, Block block) {
    return GestureDetector(
      onTap: () {
        areaToRecommends(vod.id, block.id);
      },
      child: SizedBox(
          width: 115,
          height: 140,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(7.0),
            child: Card(
              margin: const EdgeInsets.all(0),
              color: Color(0xFFefefef),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const VDIcon(VIcons.plus_gray),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "看更多",
                    style:
                        const TextStyle(fontSize: 12, color: Color(0xFF979797)),
                  )
                ],
              ),
            ),
          )),
    );
  }

  Widget buildCard2(Vod vod, Block block) {
    return GestureDetector(
      onTap: () => areaToRecommends(vod.id, block.id),
      child: SizedBox(
        width: 115,
        height: 140,
        child: Card(
            margin: const EdgeInsets.only(right: 5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(7.0),
              child: Image.network(
                "${AppController.cc.endpoint.getPhotoSidPreviewPrefix()}${vod.coverVertical!}",
                fit: BoxFit.fill,
                width: 115,
                height: 140,
              ),
            )),
      ),
    );
  }

  Widget videoCard(Video video) {
    return Stack(
      children: [
        FutureBuilder(
          future: video.loadController(),
          builder: (BuildContext context,
              AsyncSnapshot<VideoPlayerController?> snapshot) {
            if (!snapshot.hasData || snapshot.data == null) {
              return Container(
                color: Colors.white,
                child: Center(
                    child: Image.network(
                  "${AppController.cc.endpoint.getPhotoSidPreviewPrefix()}${video.coverVertical!}",
                  fit: BoxFit.fill,
                )),
              );
            } else {
              video.controller?.addListener(() {
                if (video.controller?.value.isInitialized ?? false) {
                  if (!isInitialized) {
                    setState(() {
                      isInitialized = true;
                    });
                  }
                }
              });
              return isInitialized
                  ? Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            var state = video.trigger();
                            setState(() {
                              isPlay = state as bool;
                            });
                          },
                          child: SizedBox.expand(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: SizedBox(
                                  width: video.controller?.value.size.width ?? 0,
                                  height: (video.controller?.value.size.height ?? 0),
                                  child: VideoPlayer(video.controller!),
                                ),
                              )),
                        ),
                        isPlay
                            ? Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: InkWell(
                                    onTap: () {
                                      var state = video.trigger();
                                      setState(() {
                                        isPlay = state as bool;
                                      });
                                    },
                                    child: Container(
                                      color: Color(0xffffdc00).withOpacity(0.5),
                                      width: 60,
                                      height: 60,
                                      child: const Center(
                                        child: VDIcon(
                                          VIcons.play,
                                          width: 22,
                                          height: 22,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    )
                  : Center(
                      child: Image.network(
                      "${AppController.cc.endpoint.getPhotoSidPreviewPrefix()}${video.coverVertical!}",
                      fit: BoxFit.fill,
                    ));
            }
          },
        ),
        FutureBuilder(
          future: Get.find<VodProvider>().getShortVideoDetailById(video.id),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (!snapshot.hasData || snapshot.data == null) {
              return Container();
            }
            ShortVideoDetail shortVideoDetail = snapshot.data;
            Supplier? supplier = shortVideoDetail.supplier;
            if (video.canPlay()) {
              return Stack(
                children: [
                  supplier != null
                      ? Positioned(
                          child: InkWell(
                            child: supplier.photoSid != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(30.0),
                                    child: Image.network(
                                      "${AppController.cc.endpoint.getPhotoSidPreviewPrefix()}${supplier.photoSid!}",
                                      height: 45,
                                      width: 45,
                                    ))
                                : const VDIcon(
                                    VIcons.supplier,
                                    height: 45,
                                    width: 45,
                                  ),
                            onTap: () {
                              gto('/story/up/${supplier.id.toString()}');
                            },
                          ),
                          right: 7,
                          bottom: 40 + 64 + 64 + 64,
                        )
                      : Container(),
                  supplier == null ||
                          supplier.isFollow == null ||
                          !supplier.isFollow!
                      ? Positioned(
                          child: Image(
                            width: 22,
                            height: 22,
                            image: AssetImage(
                                'assets/png/icon-follow-white@2x.png'),
                          ),
                          right: 18,
                          bottom: 40 + 64 + 64 + 55,
                        )
                      : Container(),
                  Positioned(
                    child: InkWell(
                      onTap: () {
                        if (video.isCollected ?? false) {
                          Get.find<UserProvider>().deleteFavorite([video.id]);
                        } else {
                          Get.find<UserProvider>().addFavoriteVod(video.id);
                        }
                        setState(() {
                          video.isCollected = !(video.isCollected ?? false);
                        });
                      },
                      child: (video.isCollected ?? false)
                          ? VDIcon(
                              VIcons.heart_red,
                              width: 40,
                              height: 40,
                            )
                          : VDIcon(
                              VIcons.heart_white,
                              width: 40,
                              height: 40,
                            ),
                    ),
                    right: 9,
                    bottom: 40 + 64 + 64,
                  ),
                  // Positioned(
                  //   child: Image(
                  //     width: 40,
                  //     height: 40,
                  //     image: AssetImage('assets/png/icon-chat@3x.png'),
                  //   ),
                  //   right: 9,
                  //   bottom: 40 + 64,
                  // ),
                  Positioned(
                    child: VDIcon(
                      VIcons.share_white,
                      width: 40,
                      height: 40,
                    ),
                    right: 9,
                    bottom: 40 + 64,
                  ),
                  supplier != null
                      ? Positioned(
                          child: Text(
                            "${supplier.aliasName}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                          left: 15,
                          bottom: 107,
                        )
                      : Container(),
                  Positioned(
                    child: SizedBox(
                      width: 280,
                      child: Text(
                        "${video.title}",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    left: 15,
                    bottom: 58,
                  ),
                  Positioned(
                    left: 15,
                    bottom: 26,
                    child: Row(
                      children: tags(shortVideoDetail.tag),
                    ),
                  ),
                ],
              );
            } else {
              return Stack(
                children: [
                  Container(
                    color: Colors.white,
                    child: Center(
                        child: Image.network(
                      "${AppController.cc.endpoint.getPhotoSidPreviewPrefix()}${video.coverVertical!}",
                      fit: BoxFit.fill,
                    )),
                  ),
                  supplier != null
                      ? Positioned(
                          child: InkWell(
                            child: supplier.photoSid != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(30.0),
                                    child: Image.network(
                                      "${AppController.cc.endpoint.getPhotoSidPreviewPrefix()}${supplier.photoSid!}",
                                      height: 45,
                                      width: 45,
                                    ))
                                : const VDIcon(
                                    VIcons.supplier,
                                    height: 45,
                                    width: 45,
                                  ),
                            onTap: () {
                              gto('/story/up/${supplier.id.toString()}');
                            },
                          ),
                          right: 7,
                          bottom: 40 + 64 + 64 + 64,
                        )
                      : Container(),
                  Positioned(
                    child: Image(
                      width: 22,
                      height: 22,
                      image: AssetImage('assets/png/icon-follow-white@2x.png'),
                    ),
                    right: 18,
                    bottom: 40 + 64 + 64 + 55,
                  ),
                  Positioned(
                    child: VDIcon(
                      VIcons.heart_white,
                      width: 40,
                      height: 40,
                    ),
                    right: 9,
                    bottom: 40 + 64 + 64,
                  ),
                  Positioned(
                    bottom: 0,
                    child: ClipRect(
                      // <-- clips to the 200x200 [Container] below
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 5.0,
                          sigmaY: 5.0,
                        ),
                        child: Container(
                          width: gs().width,
                          height: 146,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(.8),
                          ),
                        ),
                      ),
                    ),
                  ),
                  supplier != null
                      ? Positioned(
                          child: Text(
                            video.chargeType == 3
                                ? "${supplier.aliasName}"
                                : "此視頻為付費影片",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                          left: 16,
                          bottom: 109,
                        )
                      : Container(),
                  supplier != null
                      ? Positioned(
                          child: SizedBox(
                            width: 280,
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '此視頻 ',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 13),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        gto('/story/up/${supplier.id.toString()}');
                                      },
                                  ),
                                  TextSpan(
                                      text: '@${supplier.aliasName}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        decoration: TextDecoration.underline,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          gto('/story/up/${supplier.id.toString()}');
                                        }),
                                  TextSpan(
                                    text: ' 上傳',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 13),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        gto('/story/up/${supplier.id.toString()}');
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          left: 16,
                          bottom: 74,
                        )
                      : Container(),
                  video.chargeType == 3
                      ? Positioned(
                          child: SizedBox(
                            width: 280,
                            child: Text(
                              "解鎖後可完整播放",
                              style: TextStyle(
                                color: Colors.yellow,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          left: 16,
                          bottom: 46,
                        )
                      : Positioned(
                          child: SizedBox(
                            width: 280,
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '您的購買價格： ',
                                    style: TextStyle(
                                        color: Color(0xffcacaca), fontSize: 13),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {},
                                  ),
                                  TextSpan(
                                      text: video.buyPoints,
                                      style: TextStyle(
                                        color: Colors.yellow,
                                        fontSize: 13,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {}),
                                ],
                              ),
                            ),
                          ),
                          left: 16,
                          bottom: 46,
                        ),
                  Positioned(
                    child: SizedBox(
                      width: 106,
                      height: 36,
                      child: InkWell(
                        onTap: () async {
                          if (video.chargeType == 3) {
                            gto('/member/vip');
                          } else {
                            var code = await Get.find<VodProvider>()
                                .purchase(video.id);
                            if (code != '00' && code == '50508') {
                              alertModal(
                                title: '購買失敗',
                                content: '金幣不足，請先充值',
                                onTap: () {
                                  gto('/member/wallet');
                                },
                              );
                              return;
                            }
                            if (code != '00' && code != '50508') {
                              Fluttertoast.showToast(
                                msg: code == '50508'
                                    ? '購買失敗: 金幣不足'
                                    : '購買失敗: 系統異常',
                                gravity: ToastGravity.CENTER,
                              );
                              return;
                            }
                            // setState(() {
                            //   showBuyConfirm = false;
                            //   isLoading = true;
                            // });
                            Video nv = await Get.find<VodProvider>().getById(video.id);
                            video.chargeType = nv.chargeType;
                            video.isPreview = nv.isPreview;
                            setState(() {});

                            await Fluttertoast.showToast(
                              msg: '購買成功',
                              gravity: ToastGravity.CENTER,
                            );
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(
                            top: 8,
                            bottom: 8,
                          ),
                          decoration: BoxDecoration(
                            color: color1,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Text(
                            video.chargeType == 3 ? '升級VIP' : '付費購買',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                    right: 16,
                    bottom: 55,
                  ),
                  video.chargeType == 2
                      ? Positioned(
                          child: SizedBox(
                            width: 280,
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '購買金幣',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        decoration: TextDecoration.underline),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        gto('/member/wallet');
                                      },
                                  ),
                                  TextSpan(
                                      text: int.parse(user?.points ?? '0') <
                                              int.parse(video.buyPoints ?? '0')
                                          ? '   (金幣不足)'
                                          : '',
                                      style: TextStyle(
                                        color: Color(0xff979797),
                                        fontSize: 11,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          gto('/member/wallet');
                                        }),
                                ],
                              ),
                            ),
                          ),
                          left: 16,
                          bottom: 20,
                        )
                      : Container(),
                  Positioned(
                    child: SizedBox(
                        width: 16,
                        height: 16,
                        child: VDIcon(VIcons.close_white)),
                    right: 16,
                    bottom: 118,
                  ),
                ],
              );
            }
          },
        )
      ],
    );
  }

  Future<void> alertModal(
      {String title = '', String content = '', VoidCallback? onTap}) async {
    return showDialog(
      context: context,
      builder: (_ctx) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          titlePadding: EdgeInsets.zero,
          title: null,
          contentPadding: EdgeInsets.zero,
          content: Container(
            height: 150,
            padding:
                const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  content,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.normal),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          margin: const EdgeInsets.all(5.0),
                          padding: const EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                          ),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            color: color6,
                          ),
                          child: const Text(
                            '取消',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          if (onTap != null) {
                            onTap();
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.all(5.0),
                          padding: const EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                          ),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            color: color1,
                          ),
                          child: const Text(
                            '立刻購買',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> tags(List<VideoTag> tags) {
    var len = tags.length >= 4 ? 4 : tags.length;
    tags = tags.sublist(0, len);
    List<Widget> result = [];
    tags.forEach((e) => {
          result.add(InkWell(
            onTap: () {
              gto('/story/tag/${e.id}');
            },
            child: Container(
                padding: const EdgeInsets.only(
                  left: 8,
                  right: 8,
                  top: 4,
                  bottom: 4,
                ),
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(4.0)),
                child: Row(
                  children: [
                    Text(
                      "${e.name}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                )),
          )),
          result.add(SizedBox(
            width: 14,
          ))
        });
    return result;
  }

  // void loadUp() {
  //   Get.find<SupplierProvider>().getManyBy(page:upPages+=1 , limit: limit).then((value) => {
  //     currentLoad = int.parse(value.current) * int.parse(value.limit),
  //     upTotal = value.total,
  //     value.data.forEach((e) => suppliers.add(buildCard(e))),
  //
  //     setState((){
  //       suppliers: suppliers;
  //     })
  //   });
  // }

  showJingang(List<JinGang> jingangs) {
    return Container(
      height: 123,
      padding: const EdgeInsets.only(
          // left: 1,
          ),
      child: Theme(
        data: Theme.of(context).copyWith(
            scrollbarTheme: ScrollbarThemeData(
          thumbColor: MaterialStateProperty.all(mainBgColor),
          trackColor:
              MaterialStateProperty.all(const Color.fromRGBO(238, 238, 238, 1)),
          trackBorderColor: MaterialStateProperty.all(Colors.transparent),
          trackVisibility: MaterialStateProperty.all(true),
          mainAxisMargin: 150,
          minThumbLength: 1,
          radius: const Radius.circular(60),
          thickness: MaterialStateProperty.all(4),
          // isAlwaysShown: true,
        )),
        child: NotificationListener(
            onNotification: (scrollNotification) {
              if (scrollNotification is ScrollEndNotification &&
                  scrollNotification.metrics.extentAfter == 0) {
                // setState((){
                //   if (currentLoad <= upTotal) {
                //     loadUp();
                //   }
                // });
                return true;
              }
              return false;
            },
            child: ListView.builder(
                controller: _scrollController,
                itemCount: 1,
                scrollDirection: Axis.horizontal,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Wrap(
                          spacing: 15,
                          runSpacing: 2,
                          children: jingangs.map((e) => buildCard(e)).toList(),
                        ),
                      ),
                    ],
                  );
                })),
      ),
    );
  }
}
