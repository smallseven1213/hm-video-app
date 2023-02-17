import 'package:flutter/material.dart';

// TODO: 基本上這邊會做一些初始化的動作,
class SplashScreen extends StatelessWidget {
  // Props為圖片以及完成後的callback事件
  const SplashScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Splash Screen'),
      ),
    );
  }
}
