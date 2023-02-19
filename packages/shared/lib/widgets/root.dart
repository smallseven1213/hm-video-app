// RootWidget is the root of the widget hierarchy. it's a stateless widget

import 'package:flutter/material.dart';

/// App初始化, 會在這裡注入與初始化一些東西
class RootWidget extends StatelessWidget {
  final Widget widget;

  const RootWidget({
    Key? key,
    required this.widget,
  }) : super(key: key);

  // 在程式開始前執行setupDependencies

  @override
  Widget build(BuildContext context) {
    return widget;
  }
}
