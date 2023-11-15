import 'package:app_ra/widgets/countdown.dart';
import 'package:flutter/material.dart';
import 'package:game/widgets/game_provider.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/utils/running_main.dart';
import 'config/colors.dart';
import 'localization/i18n.dart';
import 'widgets/loading.dart';
import './routes/app_routes.dart' as app_routes;
import './routes/game_routes.dart' as game_routes;

const env = String.fromEnvironment('ENV', defaultValue: 'prod');

void main() async {
  final allRoutes = {
    ...app_routes.appRoutes,
    ...game_routes.gameRoutes,
  };

  runningMain(
    'https://b8f5f2b4ae004112a6125b24da2451c3@sentry.hmtech.club/5',
    allRoutes.keys.first,
    [
      'https://dl.dlra.info/$env/dl.json',
      'https://dl.dlra.me/$env/dl.json',
      'https://dl.dlra.club/$env/dl.json',
    ],
    allRoutes,
    AppColors.colors,
    ThemeData(
      scaffoldBackgroundColor: AppColors.colors[ColorKeys.background],
      // highlightColor: Colors.black,
      // splashColor: Colors.black,
      primaryColor: Colors.black,
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColors.colors[ColorKeys.primary],
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
        bodySmall: TextStyle(
          fontSize: 12,
          color: AppColors.colors[ColorKeys.textPrimary]!,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.colors[ColorKeys.background],
        shadowColor: AppColors.colors[ColorKeys.textPrimary]!,
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
  );
}
