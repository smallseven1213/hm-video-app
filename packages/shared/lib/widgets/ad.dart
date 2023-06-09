import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/models/index.dart';
import 'package:shared/widgets/banner_link.dart';
import 'package:shared/widgets/sid_image.dart';
import '../enums/app_routes.dart';
import '../models/banner_photo.dart';
import '../navigator/delegate.dart';
import '../services/system_config.dart';
import '../controllers/banner_controller.dart';

final systemConfig = SystemConfig();
final logger = Logger();

class Ad extends StatefulWidget {
  final String backgroundAssetPath;
  final Function? loading;

  const Ad({
    Key? key,
    required this.backgroundAssetPath,
    required this.loading,
  }) : super(key: key);

  @override
  State<Ad> createState() => AdState();
}

class AdState extends State<Ad> {
  BannerController bannerController = Get.find<BannerController>();
  late BannerPhoto currentBanner;

  int countdownSeconds = 5;
  bool imageLoaded = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // 紀錄入站次數，用來取得對應的廣告圖片
    final entryCount = systemConfig.box.read('entry-count') ?? 0;
    systemConfig.box.write('entry-count', entryCount + 1);
    final landingBanners = bannerController.banners[BannerPosition.landing];
    logger.i(landingBanners);
    if (mounted) {
      setState(() {
        currentBanner = landingBanners![entryCount % landingBanners.length];
      });
    }
  }

  startTimer() {
    // 倒數五秒
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdownSeconds == 0) {
        if (currentBanner.isAutoClose == true) {
          MyRouteDelegate.of(context).pushAndRemoveUntil(AppRoutes.home.value);
        }
        timer.cancel();
      } else {
        if (mounted) {
          setState(() {
            countdownSeconds--;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async => false,
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Positioned.fill(
              child: BannerLink(
                id: currentBanner.id,
                url: currentBanner.url ?? '',
                child: SidImage(
                  width: size.width,
                  height: size.height,
                  sid: currentBanner.photoSid.toString(),
                  fit: BoxFit.cover,
                  onLoaded: (result) {
                    logger.i('AD SID IMAGE ONLOAD');
                    startTimer();
                    setState(() => imageLoaded = true);
                  },
                  onError: (e) {
                    logger.i('AD SID IMAGE ERROR: $e');
                    MyRouteDelegate.of(context).pushAndRemoveUntil(
                        AppRoutes.home.value,
                        hasTransition: false);
                  },
                ),
              ),
            ),
            if (imageLoaded)
              Positioned(
                top: 20,
                right: 20,
                child: TextButton(
                  onPressed: () => {
                    if (countdownSeconds == 0)
                      MyRouteDelegate.of(context).pushAndRemoveUntil(
                          AppRoutes.home.value,
                          hasTransition: false)
                  },
                  child: Container(
                    width: 90,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(0, 0, 0, .5),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                    child: Center(
                      child: Text(
                        countdownSeconds == 0
                            ? '立即進入'
                            : '倒數 ${countdownSeconds.toString()}S',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            if (!imageLoaded) ...[
              Positioned.fill(
                child: Image.asset(
                  widget.backgroundAssetPath,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Center(
                child: widget.loading!(text: '取得最新資源...') ??
                    const CircularProgressIndicator(),
              ),
            ],
            Positioned(
              bottom: 10,
              right: 10,
              child: Text(
                '版本 ${systemConfig.version}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
