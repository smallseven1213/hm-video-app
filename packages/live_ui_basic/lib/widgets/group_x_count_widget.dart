import 'dart:async';

import 'package:flutter/material.dart';

import 'x_count.dart';

class GroupXCountWidget extends StatefulWidget {
  final int totalCount;

  const GroupXCountWidget({Key? key, required this.totalCount})
      : super(key: key);

  @override
  _GroupXCountWidgetState createState() => _GroupXCountWidgetState();
}

class _GroupXCountWidgetState extends State<GroupXCountWidget> {
  int _count = 1;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_count < widget.totalCount) {
        setState(() {
          _count++;
        });
      } else {
        _timer?.cancel(); // 达到 totalCount 后取消定时器
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return XCountWidget(count: _count);
  }

  @override
  void dispose() {
    _timer?.cancel(); // 确保定时器被取消以避免内存泄露
    super.dispose();
  }
}
