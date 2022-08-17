import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:wgp_video_h5app/pages/story_video_page.dart';
import 'package:wgp_video_h5app/providers/index.dart';
import 'package:wgp_video_h5app/styles.dart';

import '../configs/c_menu_bar_dark.dart';
import '../models/tags.dart';
import '../models/videos_tag.dart';

class StorySearchPage extends StatefulWidget {
  const StorySearchPage({Key? key}) : super(key: key);

  @override
  State<StorySearchPage> createState() => _StorySearchPageState();
}

class _StorySearchPageState extends State<StorySearchPage> with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;
  ScrollController _scrollController = ScrollController();
  bool isPlaying = true;
  List<Widget> videoTags = [];
  String keyword = '';
  bool loading = false;
  @override
  void initState() {
    Get.lazyPut<VRegionController>(() => VRegionController());
    Get.lazyPut<TagProvider>(() => TagProvider());

    search();
    _tabController = TabController(
      vsync: this,
      initialIndex: _currentIndex,
      length: 1,
    );
    _tabController.addListener(_handleTabChanged);
    super.initState();
        Get.find<NoticeProvider>().getMarquee().then((marqueeList) =>
        Get.find<VNoticeController>().setMarquee(marqueeList ?? []));
  }
  search() {
    if (!loading) {
      videoTags.clear();
      loading = true;
      Get.find<TagProvider>().searchShortVideoPopular(keyword).then((value) {
        if (value.isEmpty) {
          loading = false;
          return setState(() {
            videoTags.add(buildEmpty());
          });
        }
        var len = value.length >= 20 ? 20 : value.length;
        value = value.sublist(0, len);
        value.forEach((element) {
          setState(() {
            videoTags.add(buildRow(element));
          });
        });
        loading = false;
      });
    }
  }

  Widget buildRow(VideoTags e) {
    var len = e.videos?.length;
    len = (len == null) ? 0 : ((len > 9) ? 9 : len);
    List<Widget> tags = e.videos?.sublist(0, len).map((e1) => buildCard2(e, e1)).toList() ?? [];

    if (e.shortVideoTotal! >= 10) {
      tags.add(buildCard1(e));
    }

    return Column(
      children: [
        InkWell(
          onTap: () {
            gto('/story/tag/${e.id}');
          },
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('#'),
                    Text(
                      e.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(width: 5.0,height: 0,),
                    Text(
                      ' (${e.shortVideoTotal})',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xffb3b3b3),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ]),
        ),
        Container(
          margin: const EdgeInsets.only(
            left: 10,
            top: 10,
            bottom: 10,
            // right: 16,
            ),
          height: 140,
          child: Theme(
            data: Theme.of(context).copyWith(
                scrollbarTheme: ScrollbarThemeData(
                  thumbColor:
                  MaterialStateProperty.all(mainBgColor),
                  trackColor: MaterialStateProperty.all(
                      const Color.fromRGBO(238, 238, 238, 1)),
                  trackBorderColor: MaterialStateProperty.all(
                      Colors.transparent),
                  trackVisibility:
                  MaterialStateProperty.all(true),
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
                  children:tags),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildEmpty() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 50),
      child: Center(
        child: Text(
          '沒有更多了...',
          style: TextStyle(color: color5),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    // feedViewModel.controller?.dispose();
    super.dispose();
  }

  void _handleTabChanged() {
    setState(() {
      _currentIndex = _tabController.index;
    });
    // if (_currentIndex == 2) {
    //   feedViewModel.playCurrent();
    // }
    // if (_tabController.previousIndex == 2) {
    //   feedViewModel.videoSource?.listVideos?.forEach((element) {
    //     element.controller!.pause();
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    var centerWidth = gs().width - 32;
    double fIconH = gs().height / 1.612 -100;
    var likeWidth = (centerWidth - 32) / 3;
    return SafeArea(
      top: false,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          // title: Text(widget.title),
          backgroundColor: color1,
          shadowColor: Colors.transparent,
          toolbarHeight: 48,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: color1,
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
          title: Stack(
            children: [
              Transform(
                transform: Matrix4.translationValues(-26, 0, 0),
                child: const Center(
                  child: Text(
                    '發現',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
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
                ];
              },
              body: TabBarView(
                controller: _tabController,
                // physics: const NeverScrollableScrollPhysics(),
                children: [
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Material(
                      color: Colors.white,
                      child: Column(
                        children: [
                          SizedBox(
                            width: gs().width,
                            height: 64,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 15, bottom: 15, left: 15, right: 15),
                              child: TextFormField(

                                onChanged: (val) {
                                  setState(() {
                                    keyword = val;
                                    search();
                                  });

                                },
                                style: const TextStyle(
                                  // backgroundColor: Colors.white,
                                ),
                                decoration: InputDecoration(

                                  filled: true,
                                  fillColor: Color(0xfff2f2f2),
                                  contentPadding: const EdgeInsets.only(left: 16),
                                  suffixIcon: Padding(
                                    padding: EdgeInsets.all(5),
                                    child: VDIcon(VIcons.search,),
                                  ),
                                  suffixIconColor: const Color.fromRGBO(
                                      167, 167, 167, 1),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none,
                                  ),
                                  hintText: '搜尋短視頻',
                                  hintStyle: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xffb3b3b3),
                                  ),
                                  focusColor: Colors.white,

                                ),
                              ),
                            ),
                          ),
                          Column(
                            children: videoTags,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
//        bottomNavigationBar: VDBottomNavigationBar(
//          collection: _currentIndex == 2
//              ? CMenuBarDark()
//              : Get.find<VBaseMenuCollection>(),
//          activeIndex: Get.find<AppController>().navigationBarIndex,
//          onTap: Get.find<AppController>().toNamed,
//        ),
      ),
    );
  }

  buildCard() {
    return GestureDetector(
      onTap: () {
        gto('/story/up');
      },
      child: Container(
        width: gs().width / 4.4,
        margin: const EdgeInsets.only(
          left: 0,
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
                  borderRadius: BorderRadius.circular(60.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(60.0),
                  child: VDIcon.network(
                    "https://api.stt018.com/public/photos/photo/preview?sid=c554fcf6-d8bf-40a0-81e8-a8cf640ccad3",
                    width: 60,
                    height: 60,
                  ),
                ),
              ),
              const SizedBox(
                height: 3,
              ),
              Text(
                "91制片厂",
                style: const TextStyle(
                  fontSize: 12,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  buildCard1(VideoTags e) {
    return GestureDetector(
      onTap: () {
        gto('/story/tag/${e.id}');
      },
      child: SizedBox(
        width: gs().width * 0.283,
        height: gs().height * 0.164,
        child: Card(
          color: Color(0xFFefefef),
          elevation: 0,
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
                style: const TextStyle(fontSize: 12, color: Color(0xFF979797)),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCard2(VideoTags e, VideoTag VideoTag) {
    return GestureDetector(
      onTap: () async {
        TagVideos tagVideos =await Get.find<TagProvider>().getPlayList(videoId: VideoTag.id, tagId: e.id);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StoryVideoPage(videos: tagVideos.videos!, title: '#${tagVideos.name}',),
          ),
        );
      },
      child: SizedBox(
        width: 114,
        height: 140,
        child: Card(
          margin: const EdgeInsets.only(right: 5),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(7.0),
            child: Image.network(
              '${AppController.cc.endpoint.getPhotoSidPreviewPrefix()}${VideoTag.coverVertical}',
              fit: BoxFit.fill,
              width: 114,
              height: 140,
            ),
          ),
        ),
      )
    );
  }
}
