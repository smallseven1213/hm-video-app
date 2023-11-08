import 'package:game/routes/game_routes.dart';
import 'package:app_ab/widgets/countdown.dart';
import 'package:app_ab/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:game/widgets/game_provider.dart';
import 'package:shared/models/color_keys.dart'; // 如果需要管理色碼的話，使用這個
import 'package:shared/utils/running_main.dart'; // 啟動專案必須要引用shared的runningMain
import 'config/colors.dart';

// 以下自行決定App要什麼路由，路由的key管理則是統一放在shared中
// 如果此App沒有遊戲，那就不需要寫入game_routes
import './routes/app_routes.dart' as app_routes;
import 'localization/i18n.dart';

const env = String.fromEnvironment('ENV', defaultValue: 'prod');

void main() async {
  final allRoutes = {
    ...app_routes.appRoutes,
    ...gameRoutes,
  };

  runningMain(
    // [非必填]SentryDNS
    'https://f8f4eea92f0f45ba93348e5d975c8b76@sentry.hmtech.club/4',
    // [非必填]進入的第一個畫面
    allRoutes.keys.first,
    // [必填]DlJSON來源
    [
      'https://dl.dlaabb.com/$env/dl.json',
      'https://dl.dlaabb.info/$env/dl.json',
      'https://dl.dlaabb.net/$env/dl.json',
    ],
    allRoutes,
    AppColors.colors,
    ThemeData(
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
  );
}
