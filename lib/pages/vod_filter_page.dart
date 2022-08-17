import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wgp_video_h5app/base/layouts/index.dart';
import 'package:wgp_video_h5app/components/image/index.dart';
import 'package:wgp_video_h5app/components/index.dart';
import 'package:wgp_video_h5app/helpers/index.dart';
import 'package:wgp_video_h5app/providers/index.dart';
import 'package:wgp_video_h5app/styles.dart';

import '../components/image/v_d_image.dart';
import '../models/position.dart';
import '../shard.dart';

class VodFilterPage extends StatefulWidget {
  const VodFilterPage({Key? key}) : super(key: key);

  @override
  _VodFilterPageState createState() => _VodFilterPageState();
}

class _VodFilterPageState extends State<VodFilterPage> {
  List<int> regionIds = [];
  List<int> typeIds = [0];
  List<int> actorIds = [];
  List<int> publisherIds = [];
  List<int> tagIds = [];
  List<int> type2Ids = [0]; // 連載
  List<int> orderByIds = [1];
  List<BlockVod> searchedVod = [];
  // List<Vod> vods = [];
  List<Widget> vodsList = [];
  bool isSearching = false;
  bool loading = false;
  final ScrollController _scrollController = ScrollController();
  int page = 1;
  int limit = 100;
  bool isEndPage = false;
  List<Position> positions = [];

  void clear() {
    setState(() {
      regionIds = [];
      typeIds = [0];
      actorIds = [];
      publisherIds = [];
      tagIds = [];
      type2Ids = [0];
      orderByIds = [1];
      positions = [];
    });
  }

  void search() {
    setState(() {
      isSearching = true;
      isEndPage = false;
      // vods = [];
      vodsList = [];
      loadVod();
    });
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels + 50 >=
          _scrollController.position.maxScrollExtent) {
        page += 1;
        loadVod();
      }
    });
    super.initState();
    SharedPreferencesUtil.getPositions(4).then((value) => {
          setState(() {
            positions = value;
          })
        });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void loadVod() {
    if (isEndPage) return;
    List newTypeIds =  typeIds.toList();
    newTypeIds.remove(0);
    setState(() {
      loading = true;
      Get.find<VodProvider>()
          .getSimpleManyBy(
        page: page,
        limit: limit,
        tags: tagIds.join(','),
        publisherId: publisherIds.join(','),
        actors: actorIds.join(','),
        regionId: regionIds.join(','),
        // film: newTypeIds.join(','),
        film: '1',
        belong: type2Ids.isNotEmpty ? type2Ids[0] : 0,
        order: orderByIds.isNotEmpty ? orderByIds[0] : 1,
      )
          .then((value) {
        if (searchedVod.length < page) {
          setState(() {
            searchedVod.add(value);
            isEndPage = value.vods.length < limit;
            // vods.addAll(value.vods);
            var i = 0;
            while (i < value.vods.length) {
              var vod1 = value.vods[i++];
              var vod2 = (i >= value.vods.length) ? null : value.vods[i++];
              vodsList.add(
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: (gs().width - 30) / 2,
                      child: VBlockItemSmall(
                        vod1,
                        title: vod1.title,
                      ),
                    ),
                    SizedBox(
                      width: (gs().width - 30) / 2,
                      child: vod2 == null
                          ? const SizedBox.shrink()
                          : VBlockItemSmall(
                              vod2,
                              title: vod2.title,
                            ),
                    )
                  ],
                ),
              );

              if (positions.isNotEmpty && i != 0 && (i % 8).round() == 0) {
                vodsList.add(Container(
                  padding: const EdgeInsets.only(
                    top: 10,
                  ),
                  child: getRandom(),
                ));
              }
            }
            loading = false;
          });
        }
        return value;
      });
    });
  }

  LayoutBuilder getRandom() {
    Position position = positions[Random().nextInt(positions.length)];
    // Position position = Position(-1, "2e0dc9ef-6e1f-4f50-b294-c8549a4d3924", "https://www.google.com");
    return LayoutBuilder(builder: (ctx, constraints) {
      return Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: SizedBox(
            width: constraints.maxWidth,
            height: constraints.maxWidth / 4.83,
            child: GestureDetector(
                onTap: () {
                  if (position.url != null && position.url!.isNotEmpty) {
                    Get.find<AdProvider>().clickedBanner(position.id);
                    if (position.url.toString().startsWith('http://') ||
                        position.url.toString().startsWith('https://')) {
                      launch(position.url.toString());
                    } else {
                      gto(position.url.toString());
                    }
                  }
                },
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(1.0),
                    child: Stack(children: [
                      VDImage(
                        url: '${position.getPhotoUrl()}',
                      )
                    ])))),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    VDExpandableItem empty = VDExpandableItem(id: 0, name: '空');
    empty.selected = true;
    return FutureBuilder<BlockVod>(
      future: Future.value(BlockVod([], 0)),
      builder: (context, snapshot) {
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
                if (isSearching) {
                  setState(() {
                    isSearching = false;
                    page = 1;
                    searchedVod = [];
                    vodsList = [];
                  });
                } else {
                  back();
                }
              },
              enableFeedback: true,
              child: const Icon(
                Icons.arrow_back_ios,
                size: 14,
              ),
            ),
            title: Transform(
              transform: Matrix4.translationValues(-26, 0, 0),
              child: const Center(
                child: Text(
                  '篩選',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
          body: SafeArea(
            child: SizedBox(
              width: gs().width,
              child: isSearching
                  ? CustomScrollView(
                      controller: _scrollController,
                      slivers: [
                        SliverToBoxAdapter(
                          child: Container(
                            width: gs().width,
                            padding: const EdgeInsets.only(
                              top: 10,
                              bottom: 10,
                            ),
                            decoration: const BoxDecoration(
                              color: color7,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '已找到${searchedVod.isNotEmpty ? searchedVod[0].total : 0}視頻',
                              style: const TextStyle(
                                color: color5,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (_ctx, _id) {
                                return vodsList[_id];
                              },
                              childCount: vodsList.length,
                            ),
                          ),
                        ),
                      ],
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          VDExpandablePanel(
                            title: '地區',
                            selectedIds: regionIds,
                            tags: true,
                            defaultExpandable: true,
                            onSelected: (v) {
                              setState(() {
                                regionIds = v;
                              });
                            },
                            request: (s) => Get.find<RegionProvider>()
                                .getManyBy(page: 1)
                                .then((value) => value
                                    .map((e) => VDExpandableItem(
                                          id: e.id,
                                          name: e.name,
                                        ))
                                    .toList()),
                          ),
                          // VDExpandablePanel(
                          //   title: '視頻類型',
                          //   selectedIds: typeIds,
                          //   tags: true,
                          //   onSelected: (v) {
                          //     setState(() {
                          //       typeIds = v;
                          //     });
                          //   },
                          //   request: (s) => Future.value([
                          //     empty,
                          //     VDExpandableItem(id: 1, name: '電影'),
                          //     VDExpandableItem(id: 2, name: '劇集'),
                          //     VDExpandableItem(id: 3, name: '其他'),
                          //   ]),
                          // ),
                          VDExpandablePanel(
                            title: '演員',
                            selectedIds: actorIds,
                            tags: true,
                            onSelected: (v) {
                              setState(() {
                                actorIds = v;
                              });
                            },
                            searchable: true,
                            request: (keyword) => Get.find<ActorProvider>()
                                .searchBy(
                                  page: 1,
                                  name: keyword,
                                )
                                .then((value) => value
                                    .map((e) => VDExpandableItem(
                                          id: e.id,
                                          name: e.name,
                                        ))
                                    .toList()),
                          ),
                          VDExpandablePanel(
                            title: '出版商',
                            selectedIds: publisherIds,
                            tags: true,
                            onSelected: (v) {
                              setState(() {
                                publisherIds = v;
                              });
                            },
                            searchable: true,
                            request: (keyword) => Get.find<PublisherProvider>()
                                .getManyBy(
                                  page: 1,
                                  name: keyword,
                                )
                                .then((value) => value
                                    .map((e) => VDExpandableItem(
                                          id: e.id,
                                          name: e.name,
                                        ))
                                    .toList()),
                          ),
                          VDExpandablePanel(
                            title: '標籤',
                            selectedIds: tagIds,
                            tags: true,
                            onSelected: (v) {
                              setState(() {
                                tagIds = v;
                              });
                            },
                            searchable: true,
                            request: (keyword) => Get.find<TagProvider>()
                                .searchBy(
                                  page: 1,
                                  name: keyword,
                                )
                                .then((value) => value
                                    .map((e) => VDExpandableItem(
                                          id: e.id,
                                          name: e.name,
                                        ))
                                    .toList()),
                          ),
                          // VDExpandablePanel(
                          //   title: '連載',
                          //   selectedIds: type2Ids,
                          //   expandable: false,
                          //   onSelected: (v) {
                          //     setState(() {
                          //       type2Ids = v;
                          //     });
                          //   },
                          //   request: (s) => Future.value([
                          //     VDExpandableItem(id: 0, name: '不限'),
                          //     VDExpandableItem(id: 1, name: '連載'),
                          //     VDExpandableItem(id: 2, name: '非連載'),
                          //   ]),
                          // ),
                          VDExpandablePanel(
                            title: '排序',
                            selectedIds: orderByIds,
                            expandable: false,
                            onSelected: (v) {
                              setState(() {
                                orderByIds = v;
                              });
                            },
                            request: (s) => Future.value([
                              VDExpandableItem(id: 1, name: '最新'),
                              VDExpandableItem(id: 2, name: '最熱'),
                            ]),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: InkWell(
                                onTap: () {
                                  clear();
                                },
                                enableFeedback: true,
                                child: Container(
                                  width: 60,
                                  height: 30,
                                  alignment: Alignment.centerLeft,
                                  child: const Text(
                                    '清除條件',
                                    style: TextStyle(
                                      color: color4,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          InkWell(
                            onTap: () {
                              search();
                            },
                            enableFeedback: true,
                            child: Container(
                              width: gs().width - 30,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6.0),
                                color: color1,
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                '確定',
                                style: TextStyle(),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          FutureBuilder(
                            future: SharedPreferencesUtil.getPositions(3),
                            builder: (BuildContext context,
                                AsyncSnapshot<List<Position>> snapshot) {
                              List<Position>? positions = snapshot.data;
                              if (positions?.isEmpty ?? true) {
                                return Container();
                              }
                              positions = positions!;
                              Position position =
                                  positions[Random().nextInt(positions.length)];

                              return SizedBox(
                                width: (gs().width - 32),
                                child:
                                    LayoutBuilder(builder: (ctx, constraints) {
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 20),
                                    child: SizedBox(
                                      width: constraints.maxWidth,
                                      height: constraints.maxWidth / 4.83,
                                      child: GestureDetector(
                                        onTap: () {
                                          if (position.url != null &&
                                              position.url!.isNotEmpty) {
                                            Get.find<AdProvider>()
                                                .clickedBanner(position.id);
                                            if (position.url
                                                    .toString()
                                                    .startsWith('http://') ||
                                                position.url
                                                    .toString()
                                                    .startsWith('https://')) {
                                              launch(position.url.toString());
                                            } else {
                                              gto(position.url.toString());
                                            }
                                          }
                                        },
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(1.0),
                                          child: Stack(
                                            children: [
                                              VDImage(
                                                url:
                                                    '${position.getPhotoUrl()}',
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}
