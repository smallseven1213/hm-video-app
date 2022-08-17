import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wgp_video_h5app/controllers/index.dart';
import 'package:wgp_video_h5app/helpers/getx.dart';
import 'package:wgp_video_h5app/helpers/index.dart';
import 'package:wgp_video_h5app/models/index.dart';

import '../providers/index.dart';

class AdHome extends StatefulWidget {
  const AdHome({Key? key}) : super(key: key);

  @override
  _AdHomeState createState() => _AdHomeState();
}

class _AdHomeState extends State<AdHome> {
  bool started = false;
  int seconds = 5;
  List<BannerPhoto> banners = [];
  ImageProvider bannerImage = AssetImage(isDebug()
      ? 'assets/img/img-default@3x.png'
      : 'assets/img/landing/splash3@3x.png');
  bool bannerImageLoaded = false;

  final HomeController _homeController = Get.find<HomeController>();
  final VAdController _vAdController = Get.find<VAdController>();

  @override
  void initState() {
    Future.microtask(() async {
      _homeController.fetchChannels(layoutId: 1);
      started = true;
      _homeController.fetchChannels(layoutId: 2);
      _homeController.fetchChannels(layoutId: 3);
      _vAdController.addPositionBanners(5);
    });
    banners = _vAdController.positionBanners[8] ?? [];
    bannerImage = _vAdController.positionBannerImage[8] ?? bannerImage;
    bannerImageLoaded = true;
    // precacheImage(bannerImage, context);
    super.initState();
    if (banners.isEmpty) {
      Timer.periodic(const Duration(seconds: 1), (t) {
        if (!started) return;
        if (seconds > 0) {
          setState(() {
            seconds = seconds - 1;
          });
        } else {
          t.cancel();
          grto('/default');
        }
      });
      return;
    }
    Timer.periodic(const Duration(seconds: 1), (t) {
      if (!started) return;
      if (bannerImageLoaded && seconds > 0) {
        setState(() {
          seconds = seconds - 1;
        });
        // } else if (seconds < 3 && !kIsWeb) {
        //   SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      } else if (bannerImageLoaded) {
        t.cancel();
        if (banners.first.isAutoClose == true) {
          grto('/default');
        } else {
          setState(() {});
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.black,
    ));
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: GestureDetector(
          onTap: () {
            Get.find<AdProvider>().clickedBanner(banners.first.id);
            if (banners.first.url != null &&
                banners.first.url.toString().isNotEmpty) {
              launch(banners.first.url.toString());
            }
          },
          child: Stack(
            children: [
              Container(
                width: gs().width,
                height: gs().height,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: bannerImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 36, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (seconds == 0 &&
                            banners.first.isAutoClose == false) {
                          gato('/default');
                        }
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 56,
                            height: 56,
                            child: !started
                                ? const SizedBox.shrink()
                                : TweenAnimationBuilder<double>(
                                    tween: Tween<double>(begin: 0.0, end: 1),
                                    duration:
                                        const Duration(milliseconds: 5000),
                                    builder: (context, value, _) =>
                                        CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 4,
                                      value: value,
                                    ),
                                  ),
                          ),
                          Container(
                            width: 54,
                            height: 54,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.black38,
                              // border: Border.all(
                              //   width: 1.8,
                              //   color: Colors.white,
                              // ),
                              borderRadius: BorderRadius.circular(60),
                            ),
                            child: Text(
                              seconds > 0 ? '${seconds}S' : '進入',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
