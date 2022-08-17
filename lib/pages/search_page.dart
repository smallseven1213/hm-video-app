import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wgp_video_h5app/base/index.dart';
import 'package:wgp_video_h5app/base/layouts/index.dart';
import 'package:wgp_video_h5app/components/index.dart';
import 'package:wgp_video_h5app/controllers/index.dart';
import 'package:wgp_video_h5app/helpers/index.dart';
import 'package:wgp_video_h5app/models/index.dart';
import 'package:wgp_video_h5app/providers/index.dart';
import 'package:wgp_video_h5app/styles.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  TextEditingController textEditingController = TextEditingController();
  bool isTyping = false;
  bool isSearching = false;
  bool fromVideo = false;
  String keyword = '';
  late TabController _tabController;
  late final VTabCollection _tabCollection = VActorTabs();
  int _currentIndex = 0;
  List<Tag> recommendTags = [];
  BlockVod vods = BlockVod([], 0);

  @override
  void initState() {
    _tabController = TabController(
      vsync: this,
      initialIndex: _currentIndex,
      length: _tabCollection.getTabs().length,
    );
    _tabController.addListener(_handleTabChanged);
    textEditingController.addListener(() {
      setState(() {
        isTyping = textEditingController.text.isNotEmpty;
        isSearching = false;
      });
      Future.delayed(const Duration(milliseconds: 300)).then((value) {
        setState(() {
          keyword = textEditingController.text;
        });
      });
    });
    Get.find<SearchProvider>().getPopular().then((value) {
      setState(() {
        recommendTags = value;
      });
    });
    Get.find<TagProvider>().getRecommendVod().then((value) {
      setState(() {
        vods = value;
      });
    });
    super.initState();
    var kw = Get.parameters['keyword'];
    if (kw != null) {
      Future.delayed(const Duration(milliseconds: 69)).then((value) {
        textEditingController.text = kw.toString();
        setState(() {
          keyword = kw.toString();
          isSearching = true;
          isTyping = false;
          fromVideo = true;
        });
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    textEditingController.dispose();
    super.dispose();
  }

  void _handleTabChanged() {
    setState(() {
      _currentIndex = _tabController.index;
    });
  }

  void clearKeywords() {
    Get.find<VSearchController>().clearKeywords();
    setState(() {});
  }

  void clearSearch() {
    setState(() {
      isTyping = false;
      isSearching = false;
      keyword = '';
      textEditingController.text = '';
    });
  }

  void tapSearchKeyword(String name) {
    if (name.isNotEmpty) {
      Get.find<VSearchController>().addKeyword(name);
      textEditingController.text = name;
      setState(() {
        keyword = name;
        isSearching = true;
        isTyping = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            ...[
              SliverAppBar(
                backgroundColor: color1,
                toolbarHeight: 0,
                collapsedHeight: 66,
                expandedHeight: 66,
                pinned: true,
                flexibleSpace: Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            if (fromVideo) {
                              back();
                              return;
                            }
                            if (keyword.isNotEmpty) {
                              clearSearch();
                            } else {
                              back();
                            }
                          },
                          child: const SizedBox(
                            width: 54,
                            height: 54,
                            child: Icon(
                              Icons.arrow_back_ios,
                              size: 14,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 15, bottom: 15, left: 0, right: 15),
                              child: RawKeyboardListener(
                                // onSubmitted: (val) {},
                                focusNode: FocusNode(),
                                child: TextFormField(
                                  controller: textEditingController,
                                  style: const TextStyle(
                                      // backgroundColor: Colors.white,
                                      ),
                                  maxLength: 6,
                                  autofocus: true,
                                  onFieldSubmitted: (val) {
                                    tapSearchKeyword(val);
                                  },
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    counterText: "",
                                    contentPadding:
                                        const EdgeInsets.only(left: 16),
                                    suffixIcon: InkWell(
                                      onTap: () {
                                        tapSearchKeyword(
                                            textEditingController.text);
                                      },
                                      child: const VDIcon(VIcons.search),
                                    ),
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
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
            ...(!isSearching
                ? []
                : [
                    SliverPersistentHeader(
                        pinned: true,
                        delegate: VDStickyTabBarDelegate(
                          backgroundColor: color7,
                          child: VDStickyTabBar(
                            tabController: _tabController,
                            currentIndex: _currentIndex,
                            controller: _tabCollection,
                            tabBarType: 2,
                          ),
                        ))
                  ]),
            isTyping
                ? FutureBuilder<List<KeywordItemV2>>(
                    future: Get.find<SearchProvider>().getSearchKeys(keyword),
                    builder: (_ctx, _snapshot) {
                      return !_snapshot.hasData
                          ? const SliverToBoxAdapter(child: SizedBox.shrink())
                          : SliverPadding(
                              padding: const EdgeInsets.only(bottom: 20),
                              sliver: SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (_ctx, idx) {
                                    final int itemIndex = idx ~/ 2;
                                    return idx.isEven
                                        ? GestureDetector(
                                            onTap: () {
                                              tapSearchKeyword(_snapshot
                                                      .data?[itemIndex].name ??
                                                  '');
                                            },
                                            child: SizedBox(
                                              width: gs().width - 40,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 10,
                                                  left: 10,
                                                  right: 10,
                                                  bottom: 5,
                                                ),
                                                child: Text(
                                                  _snapshot.data?[itemIndex]
                                                          .name ??
                                                      '',
                                                  style: const TextStyle(
                                                      fontSize: 14),
                                                ),
                                              ),
                                            ),
                                          )
                                        : const Divider(
                                            thickness: 1,
                                          );
                                  },
                                  semanticIndexCallback: (widget, localIndex) =>
                                      localIndex.isEven
                                          ? localIndex ~/ 2
                                          : null,
                                  childCount: math.max(
                                      0, (_snapshot.data?.length ?? 0) * 2 - 1),
                                ),
                              ),
                            );
                    },
                  )
                : isSearching
                    ? FutureBuilder<List<Vod>>(
                        future: Get.find<VodProvider>().searchMany(keyword),
                        builder: (_ctx, _snapshot) {
                          List<Vod> vods = [];
                          if (_snapshot.hasData) {
                            vods = _snapshot.data ?? [];
                          }
                          return vods.isEmpty
                              ? SliverToBoxAdapter(
                                  child: Center(
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: gs().height / 4,
                                        ),
                                        const VDIcon(VIcons.empty),
                                        const SizedBox(
                                          height: 18,
                                        ),
                                        const Text(
                                          '這裡什麼都沒有',
                                          style: TextStyle(
                                            color: color6,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (_ctx, _id) {
                                      var vod = vods[_id];
                                      return VBlockLayout7(vod: vod);
                                    },
                                    childCount: vods.length,
                                  ),
                                );
                        },
                      )
                    : SliverFillRemaining(
                        hasScrollBody: true,
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: SizedBox(
                            width: gs().width,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 15,
                                ),
                                ...(Get.find<VSearchController>()
                                        .getKeywords()
                                        .isEmpty
                                    ? []
                                    : [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Padding(
                                              padding:
                                                  EdgeInsets.only(left: 15),
                                              child: Text(
                                                '搜尋歷史',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                clearKeywords();
                                              },
                                              child: const Padding(
                                                padding:
                                                    EdgeInsets.only(right: 15),
                                                child: VDIcon(VIcons.trash),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        const Divider(),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        // ....
                                        SizedBox(
                                          width: gs().width - 20,
                                          child: Wrap(
                                            children:
                                                Get.find<VSearchController>()
                                                    .getKeywords()
                                                    .map(
                                                      (e) => GestureDetector(
                                                        onTap: () {
                                                          tapSearchKeyword(e);
                                                        },
                                                        child: VVodTag(
                                                          e,
                                                          backgroundColor:
                                                              color7,
                                                          color: color2,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    )
                                                    .toList(),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        )
                                      ]),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Padding(
                                      padding: EdgeInsets.only(left: 15),
                                      child: Text(
                                        '搜尋推薦',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                const Divider(),
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  alignment: Alignment.centerLeft,
                                  child: FutureBuilder<List<Tag>>(
                                      future: Future.value(recommendTags),
                                      builder: (_ctx, _ss) {
                                        List<Tag> tags =
                                            _ss.hasData ? (_ss.data ?? []) : [];
                                        return Wrap(
                                          crossAxisAlignment:
                                              WrapCrossAlignment.start,
                                          alignment: WrapAlignment.start,
                                          children: tags
                                              .map(
                                                (e) => GestureDetector(
                                                  onTap: () {
                                                    tapSearchKeyword(e.name);
                                                  },
                                                  child: VVodTag(
                                                    e.name,
                                                    backgroundColor: color7,
                                                    color: color2,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                        );
                                      }),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Padding(
                                      padding: EdgeInsets.only(left: 15),
                                      child: Text(
                                        '熱門推薦',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                const Divider(),
                                FutureBuilder<BlockVod>(
                                  future: Future.value(vods),
                                  builder: (_ctx, _ss) {
                                    var vods =
                                        (_ss.data ?? BlockVod([], 0)).vods;
                                    return vods.isEmpty
                                        ? const SizedBox.shrink()
                                        : Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: vods.map((e) {
                                              return VBlockLayout7(
                                                vod: e,
                                                onTap: () {
                                                  Get.find<VVodController>()
                                                      .vodPlayerController
                                                      ?.pause();
                                                },
                                              );
                                            }).toList(),
                                          );
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      )
          ],
        ),
      ),
    );
  }
}
