import 'package:app_tt/widgets/countdown.dart';
import 'package:flutter/material.dart';
import 'package:game/routes/game_routes.dart';
import 'package:game/widgets/game_provider.dart';
import 'package:live_ui_basic/routes/live_routes.dart';
import 'package:shared/utils/running_main.dart';
import 'config/colors.dart';
import 'localization/i18n.dart';
import './routes/app_routes.dart' as app_routes;
import 'widgets/loading_animation.dart';

const env = String.fromEnvironment('ENV', defaultValue: 'dev');

void main() async {
  final allRoutes = {
    ...app_routes.appRoutes,
    ...gameRoutes,
    ...liveRoutes,
  };

  runningMain(
    'https://da90e5b7def842619c300395450aeb77@sentry.hmtech.club/7',
    allRoutes.keys.first,
    [
      'https://dl.dlsv.net/$env/dl.json',
    ],
    allRoutes,
    AppColors.colors,
    ThemeData(
      useMaterial3: false,
    ),
    globalLoadingWidget: ({String? text}) => Center(child: LoadingAnimation()),
    countdown: ({int countdownSeconds = 5}) =>
        Countdown(countdownSeconds: countdownSeconds),
    i18nSupport: true,
    supportedLocales: I18n.supportedLocales,
    i18nPath: 'assets/langs/langs.csv',
    expandedWidget: (child) => GameProvider(child: child),
  );
}
