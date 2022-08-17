import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wgp_video_h5app/components/index.dart';
import 'package:wgp_video_h5app/components/v_d_sticky_tab_bar_delegate2.dart';
import 'package:wgp_video_h5app/controllers/index.dart';
import 'package:wgp_video_h5app/helpers/index.dart';
import 'package:wgp_video_h5app/pages/story_video_page.dart';
import 'package:wgp_video_h5app/styles.dart';

import '../base/v_icon_collection.dart';
import '../models/supplier.dart';
import '../models/tags.dart';
import '../models/videos_tag.dart';
import '../providers/supplier_provider.dart';
import '../providers/tag_provider.dart';
import '../providers/user_provider.dart';

class StoryTagPage extends StatefulWidget {
  const StoryTagPage({Key? key}) : super(key: key);

  @override
  _StoryTagPageState createState() => _StoryTagPageState();
}

class _StoryTagPageState extends State<StoryTagPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;
  final VRegionController _regionController = Get.find<VRegionController>();
  List<Widget> recordList = [];
  int page = 1;
  int total = 0;
  int limit = 9;
  int tagId = int.parse(Get.parameters['tagId'] as String);
  bool isFollow = false;
  SupplierTag? supplier;
  @override
  void initState() {
    loadTag();

    _tabController = TabController(
      vsync: this,
      initialIndex: _currentIndex,
      length: 1,
    );
     super.initState();
    setState(() {

    });
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

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChanged() {
    setState(() {
      _currentIndex = _tabController.index;
      _regionController.setCurrentRegion(_currentIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                child: Center(
                  child: Text(
                    '#${supplier?.tagName ?? ''}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        body: supplier != null ? NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                toolbarHeight: 0,
                pinned: true,
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              Material(
                color: Colors.white,
                child: Column(
                  children: [
                    Expanded(
                      child:
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 19,
                        ),
                        child: NotificationListener<ScrollNotification>(

                          onNotification: (scrollInfo) {
                            if (scrollInfo is ScrollEndNotification &&
                                scrollInfo.metrics.extentAfter == 0) {
                              setState(() {
                                if (total >=
                                    recordList.length) {
                                  page = page + 1;
                                  loadShortVideo(page, limit, tagId);
                                }
                              });
                              return true;
                            }
                            return false;
                          },
                          child: ListView.builder(
                            cacheExtent: 55,
                            primary: false,
                            shrinkWrap: true,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: 1,
                            itemBuilder: (_bctx, idx) {
                              return Column(
                                children: [
                                  // const VDIcon(
                                  //   VIcons.supplier,
                                  //   height: 83,
                                  //   width: 83,
                                  // ),
                                  // SizedBox(
                                  //   height: 12,
                                  // ),
                                  IntrinsicHeight(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: gs().width/ 2.97,
                                        ),
                                        buildTitle1(supplier!.shortVideoTotal.toString(), "短視頻"),
                                        const VerticalDivider(
                                          // width: 10,
                                          thickness: 1,
                                          indent: 12,
                                          endIndent: 13,
                                          color: color6,
                                        ),
                                        buildTitle1(supplier!.followTotal.toString(), "關注"),
                                        SizedBox(
                                          width: gs().width / 2.97,
                                        ),
                                        // const VerticalDivider(
                                        //   // width: 10,
                                        //   thickness: 1,
                                        //   indent: 12,
                                        //   endIndent: 13,
                                        //   color: color6,
                                        // ),
                                        // buildTitle1(supplier.collectTotal.toString(), "喜愛數"),
                                        // SizedBox(
                                        //   width: gs().width / 4.46,
                                        // ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  InkWell(
                                    onTap: () => {
                                      if (supplier?.isFollow ?? false) {
                                        setState(() {
                                          if (supplier != null) {
                                            supplier?.isFollow = false;
                                            supplier?.followTotal = supplier!.followTotal! -1;
                                            Get.find<UserProvider>().deleteTagFollowRecord(supplier!.tagId);
                                          }
                                        }),
                                      } else {
                                        setState(() {
                                          if (supplier != null) {
                                            supplier?.isFollow = true;
                                            supplier?.followTotal = supplier!.followTotal! +1;
                                            Get.find<UserProvider>().addTagFollowRecord(supplier!.tagId);
                                          }
                                        }),
                                      }
                                    },
                                    child: Container(
                                      width: (gs().width) / 5.85,
                                      height: 28,
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.only(
                                        top: 5,
                                        bottom: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: (supplier?.isFollow ?? false)  ? Color(0xfff2f2f2): color1,
                                        borderRadius: BorderRadius.circular(4.0),
                                      ),
                                      child:  Text(
                                        supplier?.isFollow ?? false  ? '取消關注': '關注',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600, fontSize: 12),
                                      ),
                                    ),),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Wrap(
                                      spacing: 15,
                                      runSpacing: 2,
                                      children: recordList,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 1.3,
                    ),
                  ],
                ),
              )
            ],
          ),
        ) : Container()
    );
  }

  List chunk(List list, int chunkSize) {
    List chunks = [];
    int len = list.length;
    for (var i = 0; i < len; i += chunkSize) {
      int size = i+chunkSize;
      chunks.add(list.sublist(i, size > len ? len : size));
    }
    return chunks;
  }

  loadShortVideo(page, limit, tagId) {
    Get.find<TagProvider>().getShortVideoById(page: page, limit: limit, id: tagId.toString()).then((value) => {
      setState(() {
        chunk(value.data, 3).forEach((element) {
          recordList.add(Row(
            children: [
              element.length >= 1  ? buildCard(element[0]) : Container(),
              SizedBox(width: 1.2,),
              element.length >= 2 ? buildCard(element[1]) : Container(),
              SizedBox(width: 1.2,),
              element.length >= 3 ? buildCard(element[2]) : Container(),
            ],
          ));
          total = value.total;
        });

      })
    });
  }

  buildTitle1(String text, String text1) {
    return Column(
      children: [
        Text(
          text,
          style: TextStyle(
            color: color2,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          text1,
          style: TextStyle(color: Color(0xFF979797), fontSize: 12),
        ),
      ],
    );
  }
  buildCard(VideoTag tag) {
    double cardWidth = (gs().width -2.4) /3;
   return Stack(
      children: [
        InkWell(
          onTap: () async {
            TagVideos tagVideos =await Get.find<TagProvider>().getPlayList(videoId: tag.id, tagId: tagId);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StoryVideoPage(videos: tagVideos.videos!, title: '#${tagVideos.name}',),
              ),
            );
          },
          child: Image.network(
          '${AppController.cc.endpoint.getPhotoSidPreviewPrefix()}${tag.coverVertical}',
          width: cardWidth,
          height: cardWidth/0.756,
          fit: BoxFit.fill,
        ),),
        Positioned(
          bottom: 0,
          child: Row(
            children: [
              Container(
                width: cardWidth,
                child: Container(
                    width: cardWidth,
                    padding: const EdgeInsets.only(
                      left: 8,
                      right: 8,
                      top: 4,
                      bottom: 4,
                    ),
                    decoration:
                    BoxDecoration(color: Colors.black.withOpacity(0.4),),
                    child: Row(children: [
                      const VDIcon(
                        VIcons.play,
                        width: 12,
                        height: 12,
                      ),
                      SizedBox(width: 2,),
                      Text(
                        "4k",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      Spacer(),
                      const VDIcon(
                        VIcons.heart_gray_1,
                        width: 12,
                        height: 12,
                      ),
                      SizedBox(width: 2,),Text(
                        "324",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                    )
                ),
              )
            ],
          ),
        ),
      ],

    );
  }

  loadTag() {
    Get.find<TagProvider>().getOneTag(
        int.parse(Get.parameters['tagId'] as String)).then((value) =>
    {
      setState(() {
        tagId = value.tagId;
        loadShortVideo(page, limit, tagId);
        supplier = value;
      })
    });
  }
}
