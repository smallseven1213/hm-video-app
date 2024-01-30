import 'package:app_wl_cn1/widgets/countdown.dart';
import 'package:app_wl_cn1/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:game/routes/game_routes.dart';
import 'package:game/widgets/game_provider.dart';
import 'package:shared/models/color_keys.dart'; // 如果需要管理色码的话，使用这个
import 'package:shared/utils/running_main.dart'; // 启动专案必须要引用shared的runningMain
import 'config/colors.dart';

// 以下自行决定App要什么路由，路由的key管理则是统一放在shared中
// 如果此App没有游戏，那就不需要写入game_routes
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
    'https://8532367f0b894ccc84ef17e9d2785c1f@sentry.hmtech.club/6',
    // [非必填]进入的第一个画面
    allRoutes.keys.first,
    // [必填]DlJSON来源
    [
      'https://dl.dlwlcn1.com/$env/dl.json',
      'https://dl.dlwlcn1.net/$env/dl.json',
      'https://dl.dlwlcn1.info/$env/dl.json',
    ],
    allRoutes,
    AppColors.colors,
    ThemeData(
      scaffoldBackgroundColor: AppColors.colors[ColorKeys.background],
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      useMaterial3: false,
    ),
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
