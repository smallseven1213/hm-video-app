import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared/services/system_config.dart';
import 'package:shared/utils/setupDependencies.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../adpters/tags_adpter.dart';
import '../adpters/video_adpter.dart';
import '../adpters/video_detail_adpter.dart';
import '../models/color_keys.dart';

Future<void> runningMain(Widget widget, Map<ColorKeys, Color> appColors) async {
  // start app
  SystemConfig systemConfig = SystemConfig();

  // await SentryFlutter.init(
  //   (options) {
  //     options.dsn =
  //         'https://fa3ef717273444e6887f4e7f32901535@o4504800404373504.ingest.sentry.io/4504800405225472';

  //     options.tracesSampleRate = 1.0;
  //   },
  //   appRunner: () async {
  //     await Hive.initFlutter();
  //     // Step1: 讀取env (local)
  //     loadEnvConfig() async {
  //       print('step1: Load env with local config');
  //       await dotenv.load(fileName: "env/.${systemConfig.project}.env");
  //       print('BRAND_NAME: ${dotenv.get('BRAND_NAME')}');
  //     }

  //     // Step2: initial indexedDB (Hive)
  //     initialIndexedDB() async {
  //       print('step2: initial indexedDB (Hive)');
  //       await Hive.initFlutter();
  //       if (!kIsWeb) {
  //         var dir = await getApplicationDocumentsDirectory();
  //         await dir.create(recursive: true);
  //         Hive.init(dir.path);
  //         // ..registerAdapter(VideoHistoryAdapter());
  //       } else {
  //         // Hive.registerAdapter(VideoHistoryAdapter());
  //       }
  //     }

  //     // DI shared package
  //     setupDependencies();

  //     // DI app_gp package

  //     // set SystemConfig appColors

  //     // Running Main
  //     runApp(widget);
  //   },
  // );
  // Step1: 讀取env (local)
  // await dotenv.load(fileName: "env/.${systemConfig.project}.env");

  // Step2: initial indexedDB (Hive)
  await Hive.initFlutter();
  if (!kIsWeb) {
    var dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    Hive.init(dir.path);
  }

  Hive.registerAdapter(VideoDatabaseFieldAdapter());
  Hive.registerAdapter(TagsAdapter());
  Hive.registerAdapter(VideoDetailAdapter());

  // DI shared package
  setupDependencies();

  // DI app_gp package

  // set SystemConfig appColors

  // Running Main

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(widget);
  });
}
