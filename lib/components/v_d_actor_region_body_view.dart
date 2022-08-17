import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wgp_video_h5app/base/index.dart';
import 'package:wgp_video_h5app/components/image/index.dart';
import 'package:wgp_video_h5app/components/index.dart';
import 'package:wgp_video_h5app/helpers/index.dart';
import 'package:wgp_video_h5app/models/index.dart';
import 'package:wgp_video_h5app/providers/actor_provider.dart';
import 'package:wgp_video_h5app/styles.dart';

class VDActorRegionBodyView extends StatefulWidget {
  final int index;
  final int regionId;
  final int currentIndex;
  const VDActorRegionBodyView(
      {Key? key,
      required this.index,
      required this.regionId,
      required this.currentIndex})
      : super(key: key);

  @override
  _VDActorRegionBodyViewState createState() => _VDActorRegionBodyViewState();
}

class _VDActorRegionBodyViewState extends State<VDActorRegionBodyView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final ScrollController _scrollController = ScrollController();
  int page = 1;
  int sortBy = 1;
  int limit = 100;
  String searchVal = '';
  bool loading = false;
  List<Actor> actors = [];
  bool isLastPage = true;
  CancelableOperation? cancelableFuture;

  @override
  void initState() {
    page = 1;
    sortBy = 1;
    searchVal = '';
    isLastPage = true;
    updateActors();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels + 50 >=
          _scrollController.position.maxScrollExtent) {
        searchNextPage();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    cancelableFuture?.cancel();
    super.dispose();
  }

  Future<void> updateActors() async {
    setState(() {
      loading = true;
    });
    var value = await Get.find<ActorProvider>().getManyBy(
      page: page,
      name: searchVal,
      sortBy: sortBy,
      region: widget.regionId,
    );
    setState(() {
      isLastPage = value.length < limit;
      actors.addAll(value);
      loading = false;
    });
  }

  Future<void> searchChanged(String val) async {
    if (loading) return;
    var result = await cancelableFuture?.cancel() ?? true;
    if (result) {
      cancelableFuture = CancelableOperation.fromFuture(
        Future.delayed(const Duration(milliseconds: 666)),
        onCancel: () => true,
      ).then((p0) {
        searchVal = val;
        page = 1;
        actors.clear();
        updateActors();
      });
    }
  }

  void searchBySort(int _sortBy) {
    if (loading) return;
    page = 1;
    sortBy = _sortBy;
    actors.clear();
    updateActors();
  }

  Future<void> searchNextPage() async {
    if (isLastPage) return;
    // if (loading) return;
    page += 1;
    await updateActors();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: CustomScrollView(
        controller: _scrollController,
        scrollDirection: Axis.vertical,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                      width: (gs().width - 40) * .55,
                      height: 32,
                      child: Theme(
                        data: ThemeData(
                          hintColor: color7,
                          primaryColor: color7,
                          primaryColorDark: color7,
                        ),
                        child: TextField(
                          // controller: _editingController,
                          onChanged: searchChanged,
                          style: const TextStyle(
                              // backgroundColor: Colors.white,
                              ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.only(left: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              // borderSide: BorderSide.none,
                            ),
                            hintText: '輸入名稱',
                            hintStyle: const TextStyle(
                              fontSize: 13,
                              color: Color.fromRGBO(167, 167, 167, 1),
                            ),
                            focusColor: Colors.white,
                          ),
                        ),
                      )),
                  SizedBox(
                    width: (gs().width - 40) * .45,
                    height: 32,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: const [
                            VDIcon(VIcons.sequence),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              '排序',
                              style: TextStyle(
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            searchBySort(0);
                          },
                          child: Container(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 5, bottom: 6),
                            decoration: BoxDecoration(
                              color: sortBy == 1 ? Colors.transparent : color1,
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(
                                color: color7,
                              ),
                            ),
                            child: Row(
                              children: const [
                                Text(
                                  '視頻',
                                  style: TextStyle(
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            searchBySort(1);
                          },
                          child: Container(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 5, bottom: 6),
                            decoration: BoxDecoration(
                              color: sortBy == 1 ? color1 : Colors.transparent,
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(
                                color: color7,
                              ),
                            ),
                            child: Row(
                              children: const [
                                Text(
                                  '人氣',
                                  style: TextStyle(
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (_ctx, _id) {
                  var e = actors[_id];
                  return GestureDetector(
                    onTap: () {
                      gto('/actor/${e.id}');
                    },
                    child: SizedBox(
                      width: (gs().width - 85) / 4,
                      height: 120,
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular((gs().width - 85) / 4.0),
                            child: VDImage(
                              url: e.getPhotoUrl(),
                              width: (gs().width - 85) / 4,
                              height: (gs().width - 85) / 4,
                              flowContainer: false,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            e.name,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: actors.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 0,
                crossAxisSpacing: 10,
                childAspectRatio: 9 / 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
