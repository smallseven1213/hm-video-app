import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

final List<String> loadingTextList = [
  '檔案很大，你忍一下',
  '還沒準備好，你先悠著來',
  '精彩即將呈現',
  '努力加載中',
  '讓檔案載一會兒',
  '美好事物，值得等待',
  '拼命搬磚中',
];
class Loading extends StatelessWidget {
  final String loadingText;

  const Loading({Key? key, required this.loadingText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // add CircularProgressIndicator
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 15.0,
          width: 15.0,
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Color(0xFF486a89),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          loadingText,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF486a89),
          ),
        ),
      ],
    );
  }
}

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
  String loadingText = '';

  void _onLoading() async {
    widget.onLoading!();
    _refreshController.loadComplete();
  }

  void _onRefresh() async {
    setState(() {
      loadingText = loadingTextList[rng.nextInt(loadingTextList.length)];
    });
    // 刷新完成后，需要调用这个方法
    await widget.onRefresh!();
    _refreshController.refreshCompleted();
    setState(() {
      loadingText = '';
    });
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: false,
      controller: _refreshController,
      // dragStartBehavior: DragStartBehavior.down,
      onLoading: _onLoading,
      onRefresh: _onRefresh,
      header: CustomHeader(
        height: 40,
        builder: (_ctx, RefreshStatus? mode) {
          return SizedBox(
            child: Center(
              child: Column(
                children: [
                  mode == RefreshStatus.completed
                      ? const Text('內容已更新',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF486a89),
                          ))
                      : loadingText != ''
                          ? Loading(
                              loadingText: loadingText,
                            )
                          : const SizedBox(),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          );
        },
      ),
      child: widget.child,
    );
  }
}
