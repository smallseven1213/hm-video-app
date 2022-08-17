import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wgp_video_h5app/helpers/index.dart';
import 'package:wgp_video_h5app/models/index.dart';
import 'package:wgp_video_h5app/providers/index.dart';
import 'package:wgp_video_h5app/styles.dart';

import '../components/image/index.dart';

class PublishersPage extends StatefulWidget {
  const PublishersPage({Key? key}) : super(key: key);

  @override
  _PublishersPageState createState() => _PublishersPageState();
}

class _PublishersPageState extends State<PublishersPage> {
  final ScrollController _scrollController = ScrollController();
  int page = 1;
  int limit = 100;
  int sortBy = 0;
  String searchVal = '';
  bool loading = false;
  List<Publisher> publishers = [];
  bool isLastPage = true;
  CancelableOperation? cancelableFuture;

  @override
  void initState() {
    page = 1;
    limit = 100;
    sortBy = 0;
    searchVal = '';
    isLastPage = true;
    updatePublishers();
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

  Future<void> updatePublishers() async {
    setState(() {
      loading = true;
    });
    var value = await Get.find<PublisherProvider>().getManyBy(
      page: page,
      name: searchVal,
      sortBy: sortBy,
    );
    setState(() {
      isLastPage = value.length < limit;
      publishers.addAll(value);
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
        publishers.clear();
        updatePublishers();
      });
    }
  }

  Future<void> searchNextPage() async {
    if (isLastPage) return;
    // if (loading) return;
    page += 1;
    await updatePublishers();
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
        title: Transform(
          transform: Matrix4.translationValues(-26, 0, 0),
          child: const Center(
            child: Text(
              '出版商',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: 20,
            ),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      width: ((gs().width - 40) / 2.4),
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
                  const SizedBox(
                    width: 15,
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 20,
            ),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (_ctx, _id) {
                  var e = publishers[_id];
                  return GestureDetector(
                    onTap: () {
                      gto('/publisher/${e.id}');
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
                childCount: publishers.length,
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
