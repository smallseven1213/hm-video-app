import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared/apis/apk_api.dart';
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
    Future<Response> getResponse(
      List<String> apiList,
      Dio dio,
      RequestOptions options,
    ) async {
      List<Future<Response>> futures = [];
      for (String api in apiList) {
        futures.add(dio.get(api));
      }
      return await Future.any(futures);
    }

    Response response = await getResponse(
      systemConfig.vodHostList,
      Dio(),
      RequestOptions(),
    );

    // 設定apiHost & vodHost & imageHost & maintenance
    if (response.data != null) {
      systemConfig.setApiHost('https://api.${response.data['apl']?.first}');
      systemConfig.setVodHost('https://api.${response.data['dl']?.first}');
      systemConfig.setImageHost('https://api.${response.data['pl']?.first}');
      systemConfig.setMaintenance(
          response.data['maintenance'] == 'true' ? true : false);
    }
  }

  // Step4: 檢查維護中
  checkIsMaintenance() async {
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
    print('apkUpdate: ${apkUpdate.status}');
    if (apkUpdate.status == Status.forceUpdate) {
      showDialog<int>(
        context: context,
        barrierDismissible: false,
        builder: (_ctx) => AlertDialog(
          title: const Text('Basic dialog title'),
          content: const Text('強制更新'),
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
  }

  // Step6: 檢查是否有token (是否登入)
  // Step7: 無: 訪客登入
  //        有: 記錄用戶登入 401 > 訪客登入
  // Step8: 訪客登入 > 取得入站廣告 > 有廣告 > 廣告頁

  @override
  void initState() {
    Future.microtask(() async {
      await loadEnvConfig();
      await initialIndexedDB();
      await fetchDlJson();
      bool isMaintenance = await checkIsMaintenance();
      if (isMaintenance) return;
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
