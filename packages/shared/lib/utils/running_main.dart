import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game/utils/setup_game_dependencies.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared/utils/setup_dependencies.dart';

import '../models/color_keys.dart';

void realMain(Widget widget) async {
  await Hive.initFlutter();
  if (!kIsWeb) {
    var dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    Hive.init(dir.path);
  }

  // Hive 會crash,暫時先不用
  // Hive.registerAdapter(VideoDatabaseFieldAdapter());
  // Hive.registerAdapter(TagsAdapter());
  // Hive.registerAdapter(VideoDetailAdapter());
  // Hive.registerAdapter(ActorAdapter());

  // DI shared package
  setupDependencies();
  setupGameDependencies();

  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: [
    SystemUiOverlay.bottom,
    SystemUiOverlay.top,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(widget);
  });
}

Future<void> runningMain(Widget widget, Map<ColorKeys, Color> appColors) async {
  // start app

  // await SentryFlutter.init(
  //   (options) {
  //     options.dsn =
  //         'https://c7999b4a8ee6400c887489947f5f43fd@o996294.ingest.sentry.io/4505050671415296';
  //     options.tracesSampleRate = 1.0;
  //   },
  //   appRunner: () => realMain(widget),
  // );
  realMain(widget);
}
