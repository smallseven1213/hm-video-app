import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization_loader/easy_localization_loader.dart';
import 'package:get/get.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:flutter_web_plugins/url_strategy.dart' as url_strategy;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game/utils/setup_game_dependencies.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared/controllers/system_config_controller.dart';
import 'package:shared/utils/setup_dependencies.dart';

import '../models/color_keys.dart';
import '../widgets/root.dart' as root;

typedef GlobalLoadingWidget = Widget Function({String? text});

void realMain(Widget widget,
    {bool? i18nSupport,
    List<Locale>? supportedLocales,
    String? i18nPath}) async {
  await Hive.initFlutter();
  if (!kIsWeb) {
    var dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    Hive.init(dir.path);
  }

  setupDependencies();
  setupGameDependencies();

  WidgetsFlutterBinding.ensureInitialized();

  if (i18nSupport == true) {
    await EasyLocalization.ensureInitialized();
  }

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
      child: i18nSupport == true && i18nPath != null && supportedLocales != null
          ? EasyLocalization(
              path: i18nPath,
              supportedLocales: supportedLocales,
              assetLoader: CsvAssetLoader(),
              child: widget,
            )
          : widget,
    ));
  });
}

Future<void> runningMain(
    String sentryDSN,
    String homePath,
    List<String> dlJsonHosts,
    root.RouteObject routes,
    Map<ColorKeys, Color> appColors,
    ThemeData? theme,
    {GlobalLoadingWidget? globalLoadingWidget,
    Widget Function({int countdownSeconds})? countdown,
    bool? i18nSupport,
    List<Locale>? supportedLocales,
    String? i18nPath,
    Widget Function(Widget child)? expandedWidget,
    Locale? defaultLocale}) async {
  url_strategy.usePathUrlStrategy();

  Widget buildOuterWidget(Widget child) {
    if (expandedWidget != null) {
      return expandedWidget(child);
    } else {
      return child;
    }
  }

  SentryFlutter.init((options) {
    options.dsn = sentryDSN;
    options.tracesSampleRate = kDebugMode ? 0 : 0.1;
    // options.release = systemConfigController.version.value;
    options.environment = kDebugMode ? 'development' : 'production';
  },
      appRunner: () => realMain(
            buildOuterWidget(root.RootWidget(
              homePath: homePath,
              routes: routes,
              splashImage: 'assets/images/splash.png',
              appColors: appColors,
              loading: globalLoadingWidget,
              theme: theme,
              countdown: countdown,
              i18nSupport: i18nSupport,
              dlJsonHosts: dlJsonHosts,
              defaultLocale: defaultLocale,
            )),
            i18nSupport: i18nSupport,
            supportedLocales: supportedLocales,
            i18nPath: i18nPath,
          ));
}
