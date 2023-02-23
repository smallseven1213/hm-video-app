import 'dart:html';

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
import 'package:shared/models/apk_update.dart';
import 'package:shared/services/system_config.dart';

// TODO: 基本上這邊會做一些初始化的動作,
class Splash extends StatefulWidget {
  // Props為圖片以及完成後的callback事件
  const Splash({
    Key? key,
  }) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  SystemConfig systemConfig = SystemConfig();

  // 取得invitationCode
  getInvitationCode() async {
    String invitationCode = '';
    // web from url ?code=xxx
    if (GetPlatform.isWeb) {
      String url = window.location.href;
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
    DlApi dlApi = DlApi();
    var res = await dlApi.fetchDlJson();
    if (res != null) {
      // 設定apiHost & vodHost & imageHost & maintenance
      systemConfig.setApiHost('https://api.${res['apl']?.first}'); // https://api.pkonly8.com/
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
    ApkApi apkApi = ApkApi();
    final apkUpdate = await apkApi.checkVersion(
      version: systemConfig.version,
      agentCode: systemConfig.agentCode,
    );
    print('apkUpdate: ${apkUpdate.status} ${apkUpdate.url}');
    if (apkUpdate.status == Status.forceUpdate) {
      Get.defaultDialog(
        title: '已有新版本',
        content: const Text('請更新至最新版本'),
        textConfirm: '更新版本',
        confirmTextColor: Colors.white,
        onConfirm: () {
          Get.back();
          // TODO: 跳轉到更新頁面
          // launch('https://${apkUpdate.url ?? ''}');
          userLogin();
        },
      );
    } else if (apkUpdate.status == Status.suggestUpdate) {
      Get.defaultDialog(
        title: '已有新版本',
        content: const Text('已發布新版本，為了更流暢的觀影體驗，請更新版本'),
        textConfirm: '立即體驗',
        textCancel: '暫不升級',
        confirmTextColor: Colors.white,
        onConfirm: () {
          Get.back();
          // TODO: 跳轉到更新頁面
          // launch('https://${apkUpdate.url ?? ''}');
        },
        onCancel: () {
          Get.back();
          userLogin();
        },
      );
    }
    userLogin();
  }

  // Step6: 檢查是否有token (是否登入)
  userLogin() async {
    print('step6: 檢查是否有token (是否登入)');
    // check token from local storage has key 'auth-token'
    if (systemConfig.box.hasData('auth-token')) {
      // Step6-1: 有: 記錄用戶登入 401 > 訪客登入 > 取得入站廣告 > 有廣告 > 廣告頁
      print('step6.1: 有token');

      UserApi userApi = UserApi();
      userApi.writeUserLoginRecord();

      systemConfig.box.write('auth-token', 'eeeeee');
    } else {
      // Step6-2: 無: 訪客登入
      AuthApi authApi = AuthApi();
      String invitationCode = await getInvitationCode();
      String agentCode = systemConfig.agentCode;
      print('===========');
      print('invitationCode: $invitationCode');
      print('agentCode: $agentCode');
      final res = await authApi.guestLogin(
        invitationCode: invitationCode,
        agentCode: agentCode,
      );
    }
  }
  // Step7: 無: 訪客登入
  // Step8: 訪客登入 > 取得入站廣告 > 有廣告 > 廣告頁

  @override
  void initState() {
    Future.microtask(() async {
      await loadEnvConfig();
      await initialIndexedDB();
      final dlJson = await fetchDlJson();
      bool isMaintenance = await checkIsMaintenance();
      if (dlJson == null || isMaintenance) return;
      // ---- init end ----
      await checkApkUpdate();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
