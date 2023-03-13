import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/models/index.dart';
import 'package:shared/widgets/sid_image.dart';
import '../navigator/delegate.dart';
import '../services/system_config.dart';
import '../controllers/banner_controller.dart';

final systemConfig = SystemConfig();

class Ad extends StatefulWidget {
  const Ad({
    Key? key,
  }) : super(key: key);

  @override
  State<Ad> createState() => AdState();
}

class AdState extends State<Ad> {
  BannerController bannerController = Get.find<BannerController>();
  int countdownSeconds = 5;
  late Timer? _timer;

  @override
  void initState() {
    super.initState();
    print('AdState initState');

    // 倒數五秒
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        countdownSeconds--;
      });
      if (countdownSeconds == 0) {
        MyRouteDelegate.of(context)
            .pushAndRemoveUntil('/home', hasTransition: false);
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    // 紀錄入站次數，用來取得對應的廣告圖片
    final entryCount = systemConfig.box.read('entry-count') ?? 0;
    systemConfig.box.write('entry-count', entryCount + 1); // 紀錄入站次數

    return Obx(() => Scaffold(
          body: Center(
            child: TextButton(
              onPressed: () {
                MyRouteDelegate.of(context).pushAndRemoveUntil('/home');
              },
              child: SidImage(
                  sid: bannerController.banners[BannerPosition.landing.index]
                          [entryCount % bannerController.banners.length]
                          ['photoSid']
                      .toString()),
            ),
          ),
        ));
  }
}
