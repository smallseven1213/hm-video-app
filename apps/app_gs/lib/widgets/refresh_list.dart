import 'dart:math';

import 'package:app_gs/widgets/video_list_loading_text.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RefreshList extends StatefulWidget {
  final Function? onRefresh;
  final Function? onLoading;
  final Widget? child;

  const RefreshList({
    Key? key,
    this.onLoading,
    this.onRefresh,
    this.child,
  }) : super(key: key);

  @override
  RefreshListState createState() => RefreshListState();
}

class RefreshListState extends State<RefreshList> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  var rng = Random();
  // String loadingText = '';

  void _onLoading() async {
    widget.onLoading!();
    _refreshController.loadComplete();
  }

  void _onRefresh() async {
    // setState(() {
    //   loadingText = loadingTextList[rng.nextInt(loadingTextList.length)];
    // });
    // 刷新完成后，需要调用这个方法
    await widget.onRefresh!();
    _refreshController.refreshCompleted();
    // setState(() {
    //   loadingText = '';
    // });
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshConfiguration(
      headerTriggerDistance: 40.0,
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        controller: _refreshController,
        onLoading: _onLoading,
        onRefresh: _onRefresh,
        header: CustomHeader(
          height: 40,
          completeDuration: const Duration(milliseconds: 300),
          builder: (_ctx, RefreshStatus? mode) {
            return SizedBox(
              child: Center(
                child: Column(
                  children: [
                    if (mode == RefreshStatus.completed)
                      const Text('內容已更新',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF486a89),
                          )),
                    if (mode == RefreshStatus.refreshing)
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 15.0,
                            width: 15.0,
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFF486a89),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          VideoListLoadingText(),
                        ],
                      ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            );
          },
        ),
        child: widget.child,
      ),
    );
  }
}
