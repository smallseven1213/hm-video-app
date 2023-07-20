import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:flutter_web_plugins/url_strategy.dart' as url_strategy;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game/utils/setup_game_dependencies.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared/utils/setup_dependencies.dart';

import '../models/color_keys.dart';
import '../services/system_config.dart';
import '../widgets/root.dart';

typedef GlobalLoadingWidget = Widget Function({String? text});

void realMain(Widget widget) async {
  await Hive.initFlutter();
  if (!kIsWeb) {
    var dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    Hive.init(dir.path);
  }

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
    runApp(DefaultAssetBundle(
      bundle: SentryAssetBundle(),
      child: widget,
    ));
  });
}

Future<void> runningMain(
    String sentryDSN,
    String homePath,
    RouteObject routes,
    Map<ColorKeys, Color> appColors,
    GlobalLoadingWidget globalLoadingWidget,
    ThemeData? theme) async {
  url_strategy.usePathUrlStrategy();

  SentryFlutter.init((options) {
    options.dsn = sentryDSN;
    options.tracesSampleRate = kDebugMode ? 0 : 1.0;
    options.release = SystemConfig().version;
    options.environment = kDebugMode ? 'development' : 'production';
  },
      appRunner: () => realMain(RootWidget(
            homePath: homePath,
            routes: routes,
            splashImage: 'assets/images/splash.png',
            appColors: appColors,
            loading: globalLoadingWidget,
            theme: theme,
          )));
}
