import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:shared/models/index.dart';
import 'package:shared/widgets/banner_link.dart';
import 'package:shared/widgets/sid_image.dart';
import '../controllers/system_config_controller.dart';
import '../enums/app_routes.dart';
import '../localization/shared_localization_delegate.dart';
import '../models/banner_photo.dart';
import '../navigator/delegate.dart';
import '../controllers/banner_controller.dart';

final logger = Logger();

class Ad extends StatefulWidget {
  final String backgroundAssetPath;
  final Function? loading;
  final Widget Function({int countdownSeconds})? countdown;

  const Ad({
    Key? key,
    required this.backgroundAssetPath,
    required this.loading,
    this.countdown,
  }) : super(key: key);

  @override
  State<Ad> createState() => AdState();
}

class AdState extends State<Ad> {
  BannerController bannerController = Get.find<BannerController>();
  final systemConfigController = Get.find<SystemConfigController>();
  late BannerPhoto currentBanner;

  GetStorage box = GetStorage();

  int countdownSeconds = 0;
  bool imageLoaded = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // 紀錄入站次數，用來取得對應的廣告圖片
    final entryCount = box.read('entry-count') ?? 0;
    box.write('entry-count', entryCount + 1);
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
          MyRouteDelegate.of(context).pushAndRemoveUntil(AppRoutes.home);
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
    SharedLocalizations localizations = SharedLocalizations.of(context)!;

    final Size size = MediaQuery.of(context).size;
    return PopScope(
      canPop: false, // HC: 煩死，勿動!!
      child: Scaffold(
        body: SafeArea(
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
                          AppRoutes.home,
                          hasTransition: false);
                    },
                  ),
                ),
              ),
              if (imageLoaded)
                Positioned(
                  top: 50,
                  right: 8,
                  child: TextButton(
                      onPressed: () => {
                            if (countdownSeconds == 0)
                              MyRouteDelegate.of(context).pushAndRemoveUntil(
                                  AppRoutes.home,
                                  hasTransition: false)
                          },
                      child: widget.countdown == null
                          ? Container()
                          : widget.countdown!(
                              countdownSeconds: countdownSeconds)),
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
                  child: widget.loading!(
                          text: localizations
                              .translate('fetching_latest_resources')) ??
                      const CircularProgressIndicator(),
                ),
                Positioned(
                  bottom: kIsWeb ? 20 : 70,
                  right: 20,
                  child: Text(
                    '${localizations.translate('version')} ${systemConfigController.version.value}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
