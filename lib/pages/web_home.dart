import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wgp_video_h5app/controllers/index.dart';
import 'package:wgp_video_h5app/helpers/index.dart';
import 'package:wgp_video_h5app/models/index.dart';
import 'package:wgp_video_h5app/pages/default.dart';
import 'package:wgp_video_h5app/providers/index.dart';
import 'package:wgp_video_h5app/providers/position_provider.dart';
import 'package:wgp_video_h5app/styles.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

class WebHome extends StatefulWidget {
  const WebHome({Key? key}) : super(key: key);

  @override
  _WebHomeState createState() => _WebHomeState();
}

class _WebHomeState extends State<WebHome> {
  int _stage = 0;
  AssetImage splashBackground =
      const AssetImage('assets/img/landing/splash3@3x.png');
  double value = 0;

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
      await precacheImage(splashBackground, context);
      setState(() {
        value = .2;
      });

      AppController app = AppController.cc;
      AuthProvider _auth = Get.find();

      setState(() {
        value = .3;
      });
      if (!kIsWeb) {
        app.updateAgentCode(const String.fromEnvironment('AgentCode'));
        var cb = await Clipboard.getData(Clipboard.kTextPlain);
        app.updateInvitationCode(cb?.text ?? '');
      }

      setState(() {
        value = .4;
      });
      app.setRouteObserver(routeObserver);
      await app.init();
      UserProvider _user = Get.find();

      setState(() {
        value = .5;
      });
      if (app.token.isEmpty) {
        var token = await _auth.guestLogin();
        await app.login(token);
      }
      setState(() {
        value = .6;
      });

      try {
        var result = await _user.loginRecord(version: app.version);
        if (result == 0) {
          await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_ctx) {
                return AlertDialog(
                  backgroundColor: Colors.transparent,
                  titlePadding: EdgeInsets.zero,
                  title: null,
                  contentPadding: EdgeInsets.zero,
                  content: Container(
                    height: 120,
                    padding: const EdgeInsets.only(
                        top: 24, left: 16, right: 16, bottom: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        // Text(
                        //   title,
                        //   style: const TextStyle(
                        //       fontSize: 16, fontWeight: FontWeight.w600),
                        // ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Text(
                          '你已被登出，請重新登入',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.normal),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        GestureDetector(
                          onTap: () async {
                            var token = await _auth.guestLogin();
                            await app.login(token);
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.only(
                              top: 10,
                              bottom: 10,
                            ),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.0),
                              color: color1,
                            ),
                            child: const Text('確認'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
        }

        setState(() {
          value = .7;
        });
        VAdController _adController = Get.find();
        await _adController.addPositionBanners(8);

        setState(() {
          value = .8;
        });
        PositionProvider positionProvider = Get.find();
        positionProvider.putManyBy(positionId: 3);
        positionProvider.putManyBy(positionId: 4);
        positionProvider.putManyBy(positionId: 6);
        positionProvider.putManyBy(positionId: 7);

        // await Future.delayed(const Duration(seconds: 2));
        setState(() {
          value = .9;
        });
      } catch (err) {
        print(err);
      } finally {
        setState(() {
          _stage = 1;
        });
        AdHome();
      }
    });
    super.initState();
  }

  Future<void> AdHome() async {
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
    if (banners.isEmpty) {
      Timer.periodic(const Duration(seconds: 1), (t) {
        if (!started) return;
        if (seconds > 0) {
          setState(() {
            seconds = seconds - 1;
          });
        } else {
          t.cancel();
          setState(() {
            _stage = 2;
          });
        }
      });
    } else {
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
            setState(() {
              _stage = 2;
            });
          } else {
            setState(() {});
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_stage == 0) {
      return Scaffold(
        body: Stack(
          children: [
            isDebug()
                ? const SizedBox.shrink()
                : Container(
                    width: gs().width,
                    height: gs().height,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: splashBackground,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
            Positioned(
              bottom: 50,
              right: 5,
              left: 5,
              child: Center(
                child: Text(
                  '版本：${AppController.cc.version}',
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            value < .2
                ? const SizedBox.shrink()
                : Container(
                    width: gs().width,
                    height: gs().height,
                    alignment: Alignment.center,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.black45,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          // const SpinKitWave(
                          //   color: Colors.white70,
                          //   size: 30.0,
                          // ),
                          CircularProgressIndicator(),
                          SizedBox(
                            height: 18,
                          ),
                          Text(
                            '線路掃描中...',
                            style: TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      );
    }
    if (_stage == 1) {
      return Scaffold(
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
                          setState(() {
                            _stage = 2;
                          });
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
      );
    }
    return Default();
  }
}
