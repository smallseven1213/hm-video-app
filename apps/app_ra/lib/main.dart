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
      useMaterial3: false,
      scaffoldBackgroundColor: AppColors.colors[ColorKeys.background],
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      primaryColor: Colors.black,
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColors.colors[ColorKeys.primary],
      ),
      colorScheme: ColorScheme.light(
        primary: AppColors.colors[ColorKeys.primary] ?? Colors.white, // 主要颜色
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
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.colors[ColorKeys.primary]!; // 選中時的背景顏色
          }
          return Colors.transparent; // 默認為透明，不影響未選中狀態
        }),
        checkColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.colors[ColorKeys.background]!; // 選中時的勾勾顏色
          }
          return Colors.transparent; // 默認為透明，不影響未選中狀態
        }),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4), // 圓角
        ),
        side: BorderSide(color: AppColors.colors[ColorKeys.primary]!), // 設置邊框顏色
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
    defaultLocale: const Locale('zh', 'TW'),
  );
}
