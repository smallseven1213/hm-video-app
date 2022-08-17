import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wgp_video_h5app/components/index.dart';
import 'package:wgp_video_h5app/components/v_d_sticky_tab_bar_delegate2.dart';
import 'package:wgp_video_h5app/controllers/index.dart';
import 'package:wgp_video_h5app/helpers/index.dart';
import 'package:wgp_video_h5app/models/index.dart';
import 'package:wgp_video_h5app/pages/story_video_page.dart';
import 'package:wgp_video_h5app/providers/index.dart';
import 'package:wgp_video_h5app/styles.dart';

import '../base/v_icon_collection.dart';
import '../models/video.dart';
import '../providers/supplier_provider.dart';

class StoryUpPage extends StatefulWidget {
  const StoryUpPage({Key? key}) : super(key: key);

  @override
  _StoryUpPageState createState() => _StoryUpPageState();
}

class _StoryUpPageState extends State<StoryUpPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;
  final VRegionController _regionController = Get.find<VRegionController>();
  ScrollController _scrollController = ScrollController();
  int upId = 0;
  int page = 1;
  int total = 0;
  int limit = 9;
  List<Widget> recordList = [];
  @override
  void initState() {
    // 前一頁錯了 要給up主ＩＤ
    upId = int.parse((Get.parameters['upId'] as String));

    loadShortVideo(page, limit, upId);
    _tabController = TabController(
      vsync: this,
      initialIndex: _currentIndex,
      length: 1,
    );
    super.initState();
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
  
  loadShortVideo(page, limit, upId) {
    Get.find<SupplierProvider>().getManyBy(page: page, limit: limit, id: upId).then((value) => {
      setState(() {
        chunk(value.data, 3).forEach((element) {
          recordList.add(Row(
            children: [
              element.length >= 1 ? buildCard(element[0]) : Container(),
              SizedBox(width: 1.2,),
              element.length >= 2 ? buildCard(element[1]) : Container(),
              SizedBox(width: 1.2,),
              element.length >= 3 ? buildCard(element[2]) : Container(),
            ],
          ));
        });
        total = value.total;
      })
    });
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
    return FutureBuilder(
      future: Get.find<SupplierProvider>().getOne(upId),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (!snapshot.hasData || snapshot.data.id == 0) {
          return Scaffold(
            appBar: AppBar(
              // Here we take the value from the MyHomePage object that was created by
              // the App.build method, and use it to set our appbar title.
              // title: Text(widget.title),
              backgroundColor: mainBgColor,
              shadowColor: Colors.transparent,
              toolbarHeight: 48,
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: mainBgColor,
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
            )
          );
        }
        Supplier supplier = snapshot.data;
        return Scaffold(
            appBar: AppBar(
              // Here we take the value from the MyHomePage object that was created by
              // the App.build method, and use it to set our appbar title.
              // title: Text(widget.title),
              backgroundColor: mainBgColor,
              shadowColor: Colors.transparent,
              toolbarHeight: 48,
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: mainBgColor,
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
                        '@${supplier.aliasName}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            body:
            NestedScrollView(
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
                                    // if (!loading) {
                                    if (total >=
                                        recordList.length) {
                                      page = page + 1;
                                      loadShortVideo(page, limit, upId);
                                    }
                                    // }
                                  });
                                  print(scrollInfo);
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

                                      supplier.photoSid == null ? const VDIcon(
                                        VIcons.supplier,
                                        height: 83,
                                        width: 83,
                                      ) : ClipRRect(
                                          borderRadius: BorderRadius.circular(60.0),
                                          child: Image.network(
                                            "${AppController.cc.endpoint.getPhotoSidPreviewPrefix()}${supplier.photoSid!}",
                                            height: 83,
                                            width: 83,
                                          )),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      IntrinsicHeight(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: gs().width / 4.46,
                                            ),
                                            buildTitle1(supplier.shortVideoTotal.toString(), "短視頻"),
                                            const VerticalDivider(
                                              // width: 10,
                                              thickness: 1,
                                              indent: 12,
                                              endIndent: 13,
                                              color: color6,
                                            ),
                                            buildTitle1(supplier.followTotal.toString(), "關注"),
                                            const VerticalDivider(
                                              // width: 10,
                                              thickness: 1,
                                              indent: 12,
                                              endIndent: 13,
                                              color: color6,
                                            ),
                                            buildTitle1(supplier.collectTotal.toString(), "喜愛數"),
                                            SizedBox(
                                              width: gs().width / 4.46,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      InkWell(
                                        onTap: () => {
                                          if (supplier.isFollow!) {
                                            Get.find<UserProvider>().deleteSupplierFollowRecord(supplier.id).then((value) => {
                                              setState(() {
                                                supplier.isFollow = false;
                                              })
                                            })
                                          } else {
                                            Get.find<UserProvider>().addSupplierFollowRecord(supplier.id).then((value) => {
                                              setState(() {
                                                supplier.isFollow = true;
                                              })
                                            })
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
                                            color: supplier.isFollow! ? Color(0xfff2f2f2): color1,
                                            borderRadius: BorderRadius.circular(4.0),
                                          ),
                                          child:  Text(
                                            supplier.isFollow! ? '取消關注': '關注',
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
            )
        );

      },);
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
  buildCard(Supplier e) {
    double cardWidth = (gs().width -2.4) /3;
   return Stack(
      children: [
        InkWell(
          onTap: () async {
            SupplierVideos supplierVideos =await Get.find<SupplierProvider>().getPlayList(videoId: e.id, supplierId: upId);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StoryVideoPage(videos: supplierVideos.videos!, title: '@${supplierVideos.aliasName}',),
              ),
            );
          },
          child: Image.network(
          '${AppController.cc.endpoint.getPhotoSidPreviewPrefix()}${e.coverVertical}',
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
                        e.videoViewTimes.toString(),
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
                        e.videoCollectTimes.toString(),
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
}
