import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wgp_video_h5app/base/v_icon_collection.dart';
import 'package:wgp_video_h5app/base/v_menu_collection.dart';
import 'package:wgp_video_h5app/components/index.dart';
import 'package:wgp_video_h5app/components/v_d_bottom_navigation_bar.dart';
import 'package:wgp_video_h5app/components/v_d_icon.dart';
import 'package:wgp_video_h5app/components/v_d_sticky_tab_bar.dart';
import 'package:wgp_video_h5app/components/v_d_sticky_tab_bar_delegate.dart';
import 'package:wgp_video_h5app/controllers/app_controller.dart';
import 'package:wgp_video_h5app/controllers/index.dart';
import 'package:wgp_video_h5app/controllers/v_channel_controller.dart';
import 'package:wgp_video_h5app/controllers/v_jingang_controller.dart';
import 'package:wgp_video_h5app/helpers/getx.dart';
import 'package:wgp_video_h5app/providers/index.dart';
import 'package:wgp_video_h5app/styles.dart';

import '../base/v_ads_collection.dart';
import '../components/v_d_sticky_tab_bar_delegate1.dart';
import '../models/jingangs.dart';
import '../models/position.dart';
import '../shard.dart';

class StoryHotPage extends StatefulWidget {
  const StoryHotPage({Key? key}) : super(key: key);

  @override
  State<StoryHotPage> createState() => _StoryHotPageState();
}

class _StoryHotPageState extends State<StoryHotPage> with TickerProviderStateMixin {
  final _logger = Logger('LayoutPageLogger');
  late TabController _tabController;
  int _currentIndex = 0;
  final HomeController _homeController = Get.find<HomeController>();
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _tabController = TabController(
      vsync: this,
      initialIndex: _currentIndex,
      length: 3,
    );
    _tabController.addListener(_handleTabChanged);
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
    });
  }

  @override
  Widget build(BuildContext context) {
    var centerWidth =  gs().width -32;
    var likeWidth = (centerWidth-32 ) /3;
    return SafeArea(
      top: false,
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Material(
            color: Colors.white,
            child:
            Column(
              children: [
                FutureBuilder(
                  future: SharedPreferencesUtil.getPositions(1),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Position>> snapshot) {
                    List<VAdItem>? VAdItems = snapshot.data
                        ?.map((e) =>
                        VAdItem(e.getPhotoUrl(), url: e.url, id: e.id))
                        .toList();

                    if (VAdItems == null || VAdItems.isEmpty) {
                      VAdItems = [
                        VAdItem(
                            '${AppController.cc.endpoint.getPhotoSidPreviewPrefix()}202668a5-d651-40a6-846f-bc9978bb183a'),
                        VAdItem(
                            '${AppController.cc.endpoint.getPhotoSidPreviewPrefix()}202668a5-d651-40a6-846f-bc9978bb183a'),
                        VAdItem(
                            '${AppController.cc.endpoint.getPhotoSidPreviewPrefix()}202668a5-d651-40a6-846f-bc9978bb183a'),
                      ];
                    }
                    return VDAdsSlider(VAdItems);
                  },
                ),
                SizedBox(height: 12,),
                Row(
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
                    ]),
                Container(
                  height: 123,
                  padding: const EdgeInsets.only(
                    // left: 1,
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                        scrollbarTheme: ScrollbarThemeData(
                          thumbColor:
                          MaterialStateProperty.all(mainBgColor),
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
                          children: [
                            buildCard(),
                            buildCard(),
                            buildCard(),
                            buildCard(),
                            buildCard(),
                            buildCard(),
                            buildCard(),
                            buildCard(),
                          ]
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16,),
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      SizedBox(
                        width: 16,
                      ),
                      Text(
                        "排行榜單",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ]),
                Row(
                  children: [
                    SizedBox(width: 16,),
                    ClipRRect(
                      child: SizedBox(
                        height: 106,
                        width: likeWidth,
                        child: Stack(
                          children: [
                            Container(
                              color: Colors.white,
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Color(0xFFf2f2f2),
                                    borderRadius: BorderRadius.circular(6.0)),
                                height: 68,
                                width: likeWidth,
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 86,
                                width: likeWidth,
                                child: Column(
                                  children: [
                                    Image.asset('assets/png/1.png', width: 46, height: 50,),
                                    SizedBox(height: 6,),
                                    const Text("人氣視頻"),
                                    SizedBox(height: 10,),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 13,),
                    ClipRRect(
                      child: SizedBox(
                        height: 106,
                        width: likeWidth,
                        child: Stack(
                          children: [
                            Container(
                              color: Colors.white,
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Color(0xFFf2f2f2),
                                    borderRadius: BorderRadius.circular(6.0)),
                                height: 68,
                                width: likeWidth,
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 86,
                                width: likeWidth,
                                child: Column(
                                  children: [
                                    Image.asset('assets/png/2.png', width: 46, height: 50,),
                                    SizedBox(height: 6,),
                                    const Text("最多喜歡"),
                                    SizedBox(height: 10,),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 16,),
                    ClipRRect(
                      child: SizedBox(
                        height: 106,
                        width: likeWidth,
                        child: Stack(
                          children: [
                            Container(
                              color: Colors.white,
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Color(0xFFf2f2f2),
                                    borderRadius: BorderRadius.circular(6.0)),
                                height: 68,
                                width: likeWidth,
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 86,
                                width: likeWidth,
                                child: Column(
                                  children: [
                                    Image.asset('assets/png/3.png', width: 46, height: 50,),
                                    SizedBox(height: 6,),
                                    const Text("UP熱榜"),
                                    SizedBox(height: 10,),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),],
                ),
                SizedBox(height: 22,),
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "#區域名稱",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ]),
                Container(
                  height: 140,
                  padding: const EdgeInsets.only(
                    left: 0,
                    right: 16,
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                        scrollbarTheme: ScrollbarThemeData(
                          thumbColor:
                          MaterialStateProperty.all(mainBgColor),
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
                          children: [


                            GestureDetector(
                              onTap: () {
                                gto('/story/tag');
                              },
                              child: SizedBox(
                                width: gs().width * 0.283,
                                height: gs().height * 0.164,
                                child: Card(
                                  elevation: 0,
                                  child: Image.asset(
                                    'assets/png/ad1.png',
                                  ),
                                ),
                              ),
                            ),
                            buildCard2(),
                            buildCard2(),
                            buildCard2(),
                            buildCard2(),
                            buildCard2(),
                            buildCard2(),
                            buildCard2(),
                            buildCard1(),
                          ]
                      ),
                    ),
                  ),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "#區域名稱2",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ]),
                Container(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                        scrollbarTheme: ScrollbarThemeData(
                          thumbColor:
                          MaterialStateProperty.all(mainBgColor),
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
                    child: Column(
                      children: [
                        SizedBox(height: 12,),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                gto('/story/tag');
                              },
                              child: Image.asset(
                                'assets/png/ad1.png',
                                width: (centerWidth  -24 )/ 3,
                              ) ,
                            ),
                            SizedBox(width: 12,),
                            GestureDetector(
                              onTap: () {
                                gto('/story/tag');
                              },
                              child: Image.asset(
                                'assets/png/ad1.png',
                                width: (centerWidth  -24 )/ 3,
                              ) ,
                            ),
                            SizedBox(width: 12,),


                            GestureDetector(
                              onTap: () {
                                gto('/story/tag');
                              },
                              child: Image.asset(
                                'assets/png/ad1.png',
                                width: (centerWidth  -24 )/ 3,
                              ) ,
                            ),
                          ],
                        ),
                        SizedBox(height: 12,),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                gto('/story/tag');
                              },
                              child: Image.asset(
                                'assets/png/ad1.png',
                                width: (centerWidth  -24 )/ 3,
                              ) ,
                            ),
                            SizedBox(width: 12,),
                            GestureDetector(
                              onTap: () {
                                gto('/story/tag');
                              },
                              child: Image.asset(
                                'assets/png/ad1.png',
                                width: (centerWidth  -24 )/ 3,
                              ) ,
                            ),
                            SizedBox(width: 12,),


                            GestureDetector(
                              onTap: () {
                                gto('/story/tag');
                              },
                              child: Image.asset(
                                'assets/png/ad1.png',
                                width: (centerWidth  -24 )/ 3,
                              ) ,
                            ),
                          ],
                        ),
                        SizedBox(height: 12,),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                gto('/story/tag');
                              },
                              child: Image.asset(
                                'assets/png/ad1.png',
                                width: (centerWidth  -24 )/ 3,
                              ) ,
                            ),
                            SizedBox(width: 12,),
                            GestureDetector(
                              onTap: () {
                                gto('/story/tag');
                              },
                              child: Image.asset(
                                'assets/png/ad1.png',
                                width: (centerWidth  -24 )/ 3,
                              ) ,
                            ),
                            SizedBox(width: 12,),
                            GestureDetector(
                              onTap: () {
                                gto('/story/tag');
                              },
                              child: Image.asset(
                                'assets/png/ad1.png',
                                width: (centerWidth  -24 )/ 3,
                              ) ,
                            ),
                          ],
                        ),
                      ],
                    )
                    ,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  buildCard( ) {
    return
      GestureDetector(
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
              mainAxisAlignment:
              MainAxisAlignment.center,
              crossAxisAlignment:
              CrossAxisAlignment.center,
              children: [
                Container(
                  decoration:
                  BoxDecoration(
                    border: Border.all(
                      color: color1,
                      width: 2,
                    ),
                    borderRadius:
                    BorderRadius
                        .circular(
                        60.0),
                  ),
                  child: ClipRRect(
                    borderRadius:
                    BorderRadius
                        .circular(
                        60.0),
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
  buildCard1( ) {
    return
      GestureDetector(
        onTap: () {
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
                const VDIcon(
                    VIcons.plus_gray),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "看更多",
                  style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF979797)
                  ),
                )
              ],
            ),
          ),
        ),
      );
  }
  buildCard2( ) {
    return
      GestureDetector(
        onTap: () {
          gto('/story/tag');
        },
        child: SizedBox(
          width: gs().width * 0.283,
          height: gs().height * 0.164,
          child: Card(
            elevation: 0,
            child: Image.asset(
              'assets/png/ad1.png',
            ),
          ),
        ),
      );
  }
  buildCard3( ) {
    return
      GestureDetector(
        onTap: () {
          gto('/story/tag');
        },
        child: SizedBox(
          width: gs().width * 0.283,
          height: gs().height * 0.164,
          child: Card(
            elevation: 0,
            child: Image.asset(
              'assets/png/ad1.png',
            ),
          ),
        ),
      );
  }
}
