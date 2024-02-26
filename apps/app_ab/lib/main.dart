import 'package:game/routes/game_routes.dart';
import 'package:app_ab/widgets/countdown.dart';
import 'package:app_ab/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:game/widgets/game_provider.dart';
import 'package:shared/models/color_keys.dart'; // 如果需要管理色码的话，使用这个
import 'package:shared/utils/running_main.dart'; // 启动专案必须要引用shared的runningMain
import 'config/colors.dart';

// 以下自行决定App要什么路由，路由的key管理则是统一放在shared中
// 如果此App没有游戏，那就不需要写入game_routes
import './routes/app_routes.dart' as app_routes;
import 'localization/i18n.dart';

// const env = String.fromEnvironment('ENV', defaultValue: 'prod');
const env = 'prod';

void main() async {
  final allRoutes = {
    ...app_routes.appRoutes,
    ...gameRoutes,
  };

  runningMain(
    // [非必填]SentryDNS
    'https://f8f4eea92f0f45ba93348e5d975c8b76@sentry.hmtech.club/4',
    // [非必填]进入的第一个画面
    allRoutes.keys.first,
    // [必填]DlJSON来源
    [
      'https://dl.dl-aabb.com/$env/dl.json',
      'https://dl.dl-aabb.info/$env/dl.json',
      'https://dl.dl-aabb.net/$env/dl.json',
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
  );
}
