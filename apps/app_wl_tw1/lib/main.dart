import 'package:app_wl_tw1/widgets/countdown.dart';
import 'package:app_wl_tw1/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:game/routes/game_routes.dart';
import 'package:game/widgets/game_provider.dart';
import 'package:live_ui_basic/routes/live_routes.dart';
import 'package:shared/models/color_keys.dart'; // 如果需要管理色碼的話，使用這個
import 'package:shared/utils/running_main.dart'; // 啟動專案必須要引用shared的runningMain
import 'config/colors.dart';

// 以下自行決定App要什麼路由，路由的key管理則是統一放在shared中
// 如果此App沒有遊戲，那就不需要寫入game_routes
import './routes/app_routes.dart' as app_routes;
import 'localization/i18n.dart';

const env = String.fromEnvironment('ENV', defaultValue: 'dev');

void main() async {
  final allRoutes = {
    ...app_routes.appRoutes,
    ...gameRoutes,
    ...liveRoutes,
  };

  runningMain(
    // [非必填]SentryDNS
    'https://5ba24c3580b99782a0d36d6e63b224da@sentry.hmtech.club/3',
    // [非必填]進入的第一個畫面
    allRoutes.keys.first,
    // [必填]DlJSON來源
    [
      'https://dl.dlwltw1.com/$env/dl.json',
      'https://dl.dlwltw1.net/$env/dl.json',
      'https://dl.dlwltw1.info/$env/dl.json',
    ],
    allRoutes,
    AppColors.colors,
    ThemeData(
      scaffoldBackgroundColor: AppColors.colors[ColorKeys.background],
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      useMaterial3: false,
      dialogBackgroundColor: AppColors.colors[ColorKeys.noticeBg],
      primaryColor: AppColors.colors[ColorKeys.primary],
      disabledColor: AppColors.colors[ColorKeys.buttonBgCancel],
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primaryContainer: AppColors.colors[ColorKeys.buttonBgPrimary],
        primary: AppColors.colors[ColorKeys.textPrimary], // textPrimaryColor
      ),
    ),
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
