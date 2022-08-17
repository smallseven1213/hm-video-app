import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wgp_video_h5app/controllers/index.dart';
import 'package:wgp_video_h5app/helpers/getx.dart';
import 'package:wgp_video_h5app/helpers/index.dart';
import 'package:wgp_video_h5app/providers/index.dart';
import 'package:wgp_video_h5app/styles.dart';

import '../providers/position_provider.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AssetImage splashBackground =
      const AssetImage('assets/img/landing/splash3@3x.png');
  double value = 0;

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

      if (!kIsWeb) {
        ApkProvider apkUpdateProvider = Get.find();
        var apkUpdate = await apkUpdateProvider.checkVersion(
            version: app.version, agentCode: app.agentCode);
        if (apkUpdate.status > 1) {
          var force = apkUpdate.status > 2;
          // apkUpdate.url
          var result = await showDialog<int>(
            context: context,
            barrierDismissible: false,
            builder: (_ctx) {
              return AlertDialog(
                backgroundColor: Colors.transparent,
                titlePadding: EdgeInsets.zero,
                title: null,
                contentPadding: EdgeInsets.zero,
                content: Container(
                  height: 166,
                  padding: const EdgeInsets.only(
                      top: 24, left: 16, right: 16, bottom: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "已有新版本",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      const Text(
                        "已發布新版本，為了更流暢的觀影體驗，請更新版本",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.normal),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: [
                          ...(force
                              ? []
                              : [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context, 0);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                          top: 10,
                                          bottom: 10,
                                        ),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                          color: color6,
                                        ),
                                        child: const Text('暫不升級'),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                ]),
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                launch('https://${apkUpdate.url ?? ''}');
                                Navigator.pop(context, 1);
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
                                child: Text(force ? '更新版本' : '立即體驗'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
          print(result);
          if (result == 1) {
            // INFO: for Android
            SystemNavigator.pop();
          }
        }
      }

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
        gato('/ad_home');
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
    // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    //   statusBarColor: Colors.transparent,
    //   systemNavigationBarColor: Color.fromARGB(255, 255, 188, 0),
    // ));
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
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
      ),
    );
  }
}
