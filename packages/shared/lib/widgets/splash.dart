import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared/apis/apk_api.dart';
import 'package:shared/apis/auth_api.dart';
import 'package:shared/apis/dl_api.dart';
import 'package:shared/apis/user_api.dart';
import 'package:shared/controllers/banner_controller.dart';
import 'package:shared/models/apk_update.dart';
import 'package:shared/models/auth.dart';
import 'package:shared/services/system_config.dart';
import 'package:url_launcher/url_launcher.dart';

import '../navigator/delegate.dart';
import 'ad.dart';

class Splash extends StatefulWidget {
  const Splash({
    Key? key,
  }) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  SystemConfig systemConfig = SystemConfig();
  DlApi dlApi = DlApi();
  ApkApi apkApi = ApkApi();
  UserApi userApi = UserApi();
  AuthApi authApi = AuthApi();
  BannerController bannerController = Get.put(BannerController());

  // 取得invitationCode
  getInvitationCode() async {
    String invitationCode = '';
    // web from url ?code=xxx

    print('Uri!!!!!: ${Uri.base}');

    print('code!!!!!: ${Uri.base.queryParameters['code']}');

    if (GetPlatform.isWeb) {
      String url = Uri.base.toString();
      print('Uri!!!!!: ${Uri.base}');

      print('code!!!!!: ${Uri.base.queryParameters['code']}');

      Uri.base.queryParameters['code'] ?? '';
      final regExp = RegExp(r'code=([^&]+)');
      final code = regExp.firstMatch(url)?.group(1) ?? '';
      invitationCode = code;
    } else {
      // app from clipboard
      var cb = await Clipboard.getData(Clipboard.kTextPlain);
      invitationCode = cb?.text ?? '';
    }

    if (!RegExp('[0-9A-Za-z]{6}').hasMatch(invitationCode)) {
      invitationCode = '';
    }
    return invitationCode;
  }

  // Step1: 讀取env (local)
  loadEnvConfig() async {
    print('step1: Load env with local config');
    await dotenv.load(fileName: "env/.${systemConfig.project}.env");
    print('BRAND_NAME: ${dotenv.get('BRAND_NAME')}');
  }

  // Step2: initial indexedDB (Hive)
  initialIndexedDB() async {
    print('step2: initial indexedDB (Hive)');
    await Hive.initFlutter();
    if (!kIsWeb) {
      var dir = await getApplicationDocumentsDirectory();
      await dir.create(recursive: true);
      Hive.init(dir.path);
      // ..registerAdapter(VideoHistoryAdapter());
    } else {
      // Hive.registerAdapter(VideoHistoryAdapter());
    }
  }

  // Step3: fetch dl.json get apiHost & maintenance status
  fetchDlJson() async {
    print('step3: fetch dl.json');
    var res = await dlApi.fetchDlJson();
    if (res != null) {
      // 設定apiHost & vodHost & imageHost & maintenance
      // https://api.pkonly8.com/
      systemConfig.setApiHost('https://api.${res['apl']?.first}');
      systemConfig.setVodHost('https://api.${res['dl']?.first}');
      systemConfig.setImageHost('https://api.${res['pl']?.first}');
      systemConfig.setMaintenance(res['maintenance'] == 'true' ? true : false);
    }

    return res;
  }

  // Step4: 檢查維護中
  checkIsMaintenance() async {
    print('step4: 檢查是否維護中');
    if (systemConfig.isMaintenance) {
      showDialog<int>(
        context: context,
        barrierDismissible: false,
        builder: (_ctx) => AlertDialog(
          title: const Text('Basic dialog title'),
          content: const Text('維護中'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('確認'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
    return systemConfig.isMaintenance;
  }

  // Step5: 檢查是否有更新
  checkApkUpdate() async {
    print('step5: 檢查是否有更新');
    bool enterable = false;
    final apkUpdate = await apkApi.checkVersion(
      version: systemConfig.version,
      agentCode: systemConfig.agentCode,
    );
    print('apkUpdate: ${apkUpdate.status}');
    if (apkUpdate.status == ApkStatus.forceUpdate) {
      // use showDialog
      showDialog<int>(
        context: context,
        barrierDismissible: false,
        builder: (_ctx) => AlertDialog(
          title: const Text('Basic dialog title'),
          content: const Text('請更新至最新版本'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('確認'),
              onPressed: () {
                // widget.onNext();
                Navigator.of(context).pop();
                userLogin();
              },
            ),
          ],
        ),
      );
    } else if (apkUpdate.status == ApkStatus.suggestUpdate) {
      showDialog<int>(
        context: context,
        barrierDismissible: false,
        builder: (_ctx) => AlertDialog(
          title: Text('已有新版本'),
          content: const Text('已發布新版本，為了更流暢的觀影體驗，請更新版本'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('確認'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
                userLogin();
              },
            ),
          ],
        ),
      );
    }
    return enterable;
  }

  // Step6: 檢查是否登入 - key: 'auth-token'
  userLogin() async {
    print('step6: 檢查是否有token (是否登入)');
    print('userApi: ${userApi}');
    if (systemConfig.box.hasData('auth-token')) {
      // Step6-1: 有: 記錄用戶登入 401 > 訪客登入 > 取得入站廣告 > 有廣告 > 廣告頁
      print('step6.1: 有token');
      systemConfig.setToken(systemConfig.box.read('auth-token'));
      fetchInitialDataAndNavigate();
    } else {
      // Step6-2: 無: 訪客登入
      print('step6.2: 無token (訪客登入)');
      String invitationCode = await getInvitationCode();
      final res = await authApi.guestLogin(
        invitationCode: invitationCode,
      );
      print('res.status ${res.status}');
      if (res.status == ResponseStatus.success) {
        fetchInitialDataAndNavigate();
      } else {
        showDialog<int>(
          context: context,
          barrierDismissible: false,
          builder: (_ctx) => AlertDialog(
            title: Text('失敗'),
            content: const Text('帳號建立失敗，裝置停用'),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('確認'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      }
      // TODO: 被封號的話，顯示帳號建立失敗，裝置停用
    }
  }

  // Step7.1: 取得nav bar內容
  getNavBar() {
    print('step7.1: 取得nav bar內容');
    // final NavBarController navBarController = Get.put(NavBarController());
    //  navBarController.fetchNavBar();
  }

  // Step7: 在首頁前要取得的資料
  // Step7.1: 取得nav bar內容
  // Step7.2: 取得入站廣告 > 有廣告 > 廣告頁
  fetchInitialDataAndNavigate() async {
    userApi.writeUserLoginRecord();
    getNavBar();
    print('step7.2: 取得入站廣告 > 有廣告 > 廣告頁');
    List landingBanners = await bannerController.fetchBanner();

    // 停留在閃屏一下，再跳轉
    countdownRedirect(String path) {
      int count = 2;
      Timer.periodic(const Duration(seconds: 1), (timer) {
        count--;
        if (count == 0) {
          timer.cancel();
          Get.offNamed(path);
        }
      });
    }

    if (landingBanners.isEmpty) {
      countdownRedirect('/home');
    } else {
      countdownRedirect('/ad');
    }
  }

  @override
  void initState() {
    Future.microtask(() async {
      loadEnvConfig();
      initialIndexedDB();
      final dlJson = await fetchDlJson();
      bool isMaintenance = await checkIsMaintenance();
      if (dlJson == null || isMaintenance) return;
      // ---- init end ----
      bool enterable = await checkApkUpdate();
      print('enterable: $enterable');
      if (enterable) {
        await userLogin();
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
    return Scaffold(
      body: Center(
        child: TextButton(
          child: Text('Next~~'),
          onPressed: () {
            print('被push前');
            MyRouteDelegate.of(context).pushAndRemoveUntil('/ad');
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (BuildContext context) {
            //       return Ad(
            //         onEnd: widget.onEnd,
            //       );
            //     },
            //   ),
            // );
          },
        ),
      ),
    );
  }
}
