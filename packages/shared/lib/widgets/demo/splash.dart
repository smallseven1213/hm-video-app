import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'ad.dart';

// TODO: 基本上這邊會做一些初始化的動作,
class SplashDemo extends StatelessWidget {
  // Props為圖片以及完成後的callback事件
  const SplashDemo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('Splash Screen'),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Get.offNamed('/ad');
      }),
    );
  }
}
