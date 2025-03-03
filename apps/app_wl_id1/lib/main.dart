import 'package:app_wl_id1/widgets/countdown.dart';
import 'package:app_wl_id1/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:game/enums/game_app_routes.dart';
import 'package:game/routes/game_routes.dart';
import 'package:game/widgets/game_provider.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/utils/running_main.dart';
import 'package:live_ui_basic/routes/live_routes.dart';
import 'config/colors.dart';

// import './routes/app_routes.dart'
//     if (dart.library.html) './routes/app_routes_web.dart' as app_routes;
import './routes/app_routes.dart' as app_routes;
import 'localization/i18n.dart';

const env = String.fromEnvironment('ENV', defaultValue: 'dev');

void main() async {
  // clone gameRoutes 並修改GameAppRoutes.lobby的值
  // final Map<String, RouteWidgetBuilder> overrideGameRoutes = {
  //   ...gameRoutes,
  //   GameAppRoutes.lobby: (context, args) => Container(),
  // };
  gameRoutes[GameAppRoutes.lobby] = (context, args) => Container();

  final allRoutes = {
    ...app_routes.appRoutes,
    ...gameRoutes,
    ...liveRoutes,
  };

  runningMain(
      'https://f7756bd03b4595f0c4416415a3f857db@sentry.hmtech.club/6',
      allRoutes.keys.first,
      [
        'https://dl.dlwlid1.com/$env/dl.json',
        'https://dl.dlwlid1.net/$env/dl.json',
        'https://dl.dlwlid1.info/$env/dl.json',
      ],
      allRoutes,
      AppColors.colors,
      ThemeData(
        useMaterial3: false,
        scaffoldBackgroundColor: AppColors.colors[ColorKeys.background],
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
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
      defaultLocale: const Locale('id', 'ID'));
}
