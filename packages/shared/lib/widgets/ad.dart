import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/models/index.dart';
import 'package:shared/widgets/sid_image.dart';
import '../navigator/delegate.dart';
import '../services/system_config.dart';
import '../controllers/banner_controller.dart';
import '../models/index.dart';

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
  late BannerPhoto currentBanner;

  int countdownSeconds = 5;

  @override
  void initState() {
    print('AdState initState');

    // 紀錄入站次數，用來取得對應的廣告圖片
    final entryCount = systemConfig.box.read('entry-count') ?? 0;
    systemConfig.box.write('entry-count', entryCount + 1);
    final landingBanners =
        bannerController.banners[BannerPosition.landing.index];
    setState(() {
      currentBanner = landingBanners[entryCount % landingBanners.length];
    });

    // 倒數五秒
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdownSeconds == 0) {
        // if (currentBanner.isAutoClose == true) {
        //   MyRouteDelegate.of(context).pushAndRemoveUntil('/home');
        // }
        timer.cancel();
      } else {
        setState(() {
          countdownSeconds--;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: SidImage(
              width: size.width,
              height: size.height,
              sid: currentBanner.photoSid.toString(),
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: TextButton(
              onPressed: () => {
                if (countdownSeconds == 0)
                  MyRouteDelegate.of(context).pushAndRemoveUntil('/home')
              },
              child: Container(
                width: 90,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(255, 255, 255, .5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    countdownSeconds == 0
                        ? '立即進入'
                        : '倒數${countdownSeconds.toString()}s',
                    style: const TextStyle(
                      color: Color.fromRGBO(34, 34, 34, 0.949),
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
