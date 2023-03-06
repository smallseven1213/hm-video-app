import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/models/index.dart';
import '../navigator/delegate.dart';
import '../services/system_config.dart';
import '../controllers/banner_controller.dart';

final systemConfig = SystemConfig();

class Ad extends StatefulWidget {
  final void Function() onNext;

  const Ad({
    Key? key,
  }) : super(key: key);

  @override
  State<Ad> createState() => AdState();
}

class AdState extends State<Ad> {
  BannerController bannerController = Get.put(BannerController());

  @override
  void initState() {
    super.initState();
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
              child: Text(
                bannerController.banners[BannerPosition.landing.index] !=
                            null &&
                        bannerController.banners.isNotEmpty
                    ? bannerController.banners[BannerPosition.landing.index]
                            [entryCount % bannerController.banners.length]
                        .toString()
                    : 'default splash image',
              ),
            ),
          ),
        ));
              
  }
}
