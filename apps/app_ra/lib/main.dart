import 'package:app_ra/widgets/countdown.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/utils/running_main.dart';
import 'config/colors.dart';
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
    'https://5975596ddf0f4a6b95b09de1adda3d53@sentry.hmtech.club/4',
    allRoutes.keys.first,
    [
      'https://dl.dlra.info/$env/dl.json',
      'https://dl.dlra.me/$env/dl.json',
      'https://dl.dlra.club/$env/dl.json',
    ],
    allRoutes,
    AppColors.colors,
    ({String? text}) => Loading(loadingText: text ?? '正在加载...'),
    ThemeData(
      scaffoldBackgroundColor: AppColors.colors[ColorKeys.background],
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      primaryColor: AppColors.colors[ColorKeys.primary],
      textTheme: TextTheme(
        bodySmall: TextStyle(
          fontSize: 12,
          color: AppColors.colors[ColorKeys.textPrimary]!,
        ),
      ),
    ),
    ({int countdownSeconds = 5}) =>
        Countdown(countdownSeconds: countdownSeconds),
  );
}
