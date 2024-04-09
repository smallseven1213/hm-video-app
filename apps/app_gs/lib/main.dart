import 'package:app_gs/widgets/countdown.dart';
import 'package:app_gs/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:game/routes/game_routes.dart';
import 'package:game/widgets/game_provider.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/utils/running_main.dart';
import 'config/colors.dart';

// import './routes/app_routes.dart'
//     if (dart.library.html) './routes/app_routes_web.dart' as app_routes;
import './routes/app_routes.dart' as app_routes;
import 'localization/i18n.dart';

const env = String.fromEnvironment('ENV', defaultValue: 'dev');

void main() async {
  final allRoutes = {
    ...app_routes.appRoutes,
    ...gameRoutes,
  };

  runningMain(
    'https://1faee0b12b854234b5bfb9546a7d5927@sentry.hmtech.club/2',
    allRoutes.keys.first,
    [
      'https://dl.dlgs.app/$env/dl.json',
      'https://dl.dlgs.one/$env/dl.json',
      'https://dl.dlgs.info/$env/dl.json',
    ],
    allRoutes,
    AppColors.colors,
    ThemeData(
        useMaterial3: false,
        scaffoldBackgroundColor: AppColors.colors[ColorKeys.background],
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent),
    globalLoadingWidget: ({String? text}) =>
        Loading(loadingText: text ?? '正在加载...'),
    countdown: ({int countdownSeconds = 5}) =>
        Countdown(countdownSeconds: countdownSeconds),
    i18nSupport: true,
    supportedLocales: I18n.supportedLocales,
    i18nPath: 'assets/langs/langs.csv',
    expandedWidget: (child) => GameProvider(child: child),
    defaultLocale: const Locale('zh', 'TW'),
  );
}
