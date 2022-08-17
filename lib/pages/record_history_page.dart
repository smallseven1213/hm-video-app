import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wgp_video_h5app/base/index.dart';
import 'package:wgp_video_h5app/base/layouts/index.dart';
import 'package:wgp_video_h5app/components/index.dart';
import 'package:wgp_video_h5app/helpers/index.dart';
import 'package:wgp_video_h5app/models/index.dart';
import 'package:wgp_video_h5app/providers/index.dart';
import 'package:wgp_video_h5app/styles.dart';

class RecordHistoryPage extends StatefulWidget {
  const RecordHistoryPage({Key? key}) : super(key: key);

  @override
  _RecordHistoryPageState createState() => _RecordHistoryPageState();
}

class _RecordHistoryPageState extends State<RecordHistoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late final VTabCollection _tabCollection = VActorTabs();
  int _currentIndex = 0;
  bool isEditing = false;
  List<int> editingVods = [];
  List<int> vodIds = [];
  List<Vod> vods = [];

  @override
  void initState() {
    _tabController = TabController(
      vsync: this,
      initialIndex: _currentIndex,
      length: _tabCollection.getTabs().length,
    );
    _tabController.addListener(_handleTabChanged);
    updateVod();
    super.initState();
  }

  void updateVod() {
    Get.find<UserProvider>().getPlayHistory().then((value) {
      setState(() {
        vods = value.vods;
        vodIds = vods.map((e) => e.id).toList();
      });
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
    });
  }

  void changeEditMode(bool editing) {
    setState(() {
      isEditing = editing;
      editingVods = [];
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
              child: const Center(
                child: Text(
                  '觀看紀錄',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Transform(
              transform: Matrix4.translationValues(0, 5, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      changeEditMode(!isEditing);
                    },
                    child: Container(
                      width: 40,
                      height: 20,
                      alignment: Alignment.center,
                      // decoration: BoxDecoration(color: Colors.red),
                      child: Text(
                        isEditing ? '取消' : '編輯',
                        style: const TextStyle(
                          fontSize: 12,
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
      body: CustomScrollView(slivers: [
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
          ),
        ),
        vods.isEmpty
            ? SliverFillRemaining(
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
            : SliverPadding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate((_ctx, _idx) {
                    var e = vods[_idx];
                    return Container(
                      width: (gs().width - 45) / 2,
                      margin: const EdgeInsets.only(top: 5),
                      child: isEditing
                          ? Stack(
                              clipBehavior: Clip.none,
                              children: [
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    setState(() {
                                      if (editingVods.contains(e.id)) {
                                        editingVods.remove(e.id);
                                      } else {
                                        editingVods = [...editingVods, e.id];
                                      }
                                    });
                                  },
                                  child: IgnorePointer(
                                    ignoring: true,
                                    child: VBlockItemSmall(
                                      e,
                                      title: e.title,
                                    ),
                                  ),
                                ),
                                !editingVods.contains(e.id)
                                    ? Positioned(
                                        top: -5,
                                        right: -5,
                                        child: Container(
                                          width: 24,
                                          height: 24,
                                          padding: const EdgeInsets.all(5.0),
                                          decoration: BoxDecoration(
                                            color: color7,
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(32.0),
                                          ),
                                        ),
                                      )
                                    : Positioned(
                                        top: -5,
                                        right: -5,
                                        child: Container(
                                          width: 24,
                                          height: 24,
                                          padding: const EdgeInsets.all(5.0),
                                          decoration: BoxDecoration(
                                            color: color1,
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(32.0),
                                          ),
                                          child:
                                              const VDIcon(VIcons.check_black),
                                        ),
                                      ),
                              ],
                            )
                          : VBlockItemSmall(
                              e,
                              title: e.title,
                            ),
                    );
                  }, childCount: vods.length),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 16 / 12.5,
                  ),
                ),
              ),
      ]),
      bottomSheet: isEditing
          ? Container(
              height: 90,
              alignment: Alignment.center,
              decoration:
                  const BoxDecoration(color: Color.fromRGBO(0, 0, 0, .65)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (editingVods.isNotEmpty) {
                          editingVods = [];
                        } else {
                          editingVods = vodIds;
                        }
                      });
                    },
                    child: Container(
                      width: (gs().width - 48) / 2,
                      height: 40,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(
                        top: 8,
                        bottom: 8,
                      ),
                      decoration: BoxDecoration(
                        color: color7,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: const Text(
                        '全選',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      await Get.find<UserProvider>()
                          .deletePlayHistory(editingVods);
                      updateVod();
                    },
                    child: Container(
                      width: (gs().width - 48) / 2,
                      height: 40,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(
                        top: 8,
                        bottom: 8,
                      ),
                      decoration: BoxDecoration(
                        color: color1,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: const Text(
                        '刪除',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
