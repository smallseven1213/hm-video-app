import 'package:app_wl_cn1/widgets/countdown.dart';
import 'package:app_wl_cn1/widgets/loading.dart';
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
    'https://4c088f6da3c1c527b05a5f508f134e2a@sentry.hmtech.club/8',
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
      dialogBackgroundColor: AppColors.colors[ColorKeys.noticeBg],
      primaryColor: AppColors.colors[ColorKeys.primary],
      disabledColor: AppColors.colors[ColorKeys.buttonBgCancel],
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primaryContainer: AppColors.colors[ColorKeys.buttonBgPrimary],
        primary: AppColors.colors[ColorKeys.textPrimary], // textPrimaryColor
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.colors[ColorKeys.textPrimary]!,
        ),
        headlineMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.colors[ColorKeys.textPrimary]!,
        ),
        headlineSmall: TextStyle(
          fontSize: 14,
          color: AppColors.colors[ColorKeys.textPrimary]!,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          color: AppColors.colors[ColorKeys.textPrimary]!,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.colors[ColorKeys.background],
        // shad /owColor: AppColors.colors[ColorKeys.textPrimary]!,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(8),
          ),
        ),
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
    defaultLocale: const Locale('zh', 'CN'),
  );
}
