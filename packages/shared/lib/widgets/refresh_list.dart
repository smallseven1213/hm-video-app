import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../localization/shared_localization_delegate.dart';

class RefreshList extends StatefulWidget {
  final Function? onRefresh;
  final Function? onLoading;
  final Function? onRefreshEnd;
  final Widget? loadingWidget;
  final Text? loadingText;
  final Widget? child;

  const RefreshList({
    Key? key,
    this.onLoading,
    this.onRefresh,
    this.onRefreshEnd,
    this.loadingText,
    this.child,
    this.loadingWidget,
  }) : super(key: key);

  @override
  RefreshListState createState() => RefreshListState();
}

class RefreshListState extends State<RefreshList> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  var rng = Random();

  void _onLoading() async {
    widget.onLoading!();
    _refreshController.loadComplete();
  }

  void _onRefresh() async {
    // 刷新完成后，需要调用这个方法
    if (widget.onRefresh == null) return;
    await widget.onRefresh!();
    await Future.delayed(const Duration(milliseconds: 500)); // 加延遲
    _refreshController.refreshCompleted();
    if (widget.onRefreshEnd == null) return;
    widget.onRefreshEnd!();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SharedLocalizations localizations = SharedLocalizations.of(context)!;

    return RefreshConfiguration(
      headerTriggerDistance: 40.0,
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        controller: _refreshController,
        onLoading: _onLoading,
        onRefresh: _onRefresh,
        header: CustomHeader(
          height: 50,
          completeDuration: const Duration(milliseconds: 300),
          builder: (ctx, RefreshStatus? mode) {
            return SizedBox(
              child: Center(
                child: Column(
                  children: [
                    if (mode == RefreshStatus.completed)
                      widget.loadingText ??
                          Text(localizations.translate('content_updated'),
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF486a89),
                              )),
                    if (mode == RefreshStatus.refreshing)
                      // ignore: prefer_const_constructors
                      widget.loadingWidget ?? Container(),
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
