import 'package:app_gs/widgets/loading.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared/services/system_config.dart';
import 'package:shared/utils/running_main.dart';
import 'package:shared/widgets/root.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';

import 'config/colors.dart';

// 載入非Web版的路由設定
import './routes/app_routes.dart'
    if (dart.library.html) './routes/app_routes_web.dart' as app_routes;
import './routes/game_routes.dart' as game_routes;

void main() async {
  usePathUrlStrategy();

  if (kDebugMode) {
    runningMain(const MyApp(), AppColors.colors);
  } else {
    await SentryFlutter.init((options) {
      options.dsn =
          'https://1b4441d1f4464b93a69208281ab77d4b@sentry.hmtech.site/2';
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = kDebugMode ? 0 : 1.0;
      options.release = SystemConfig().version;
      options.environment = kDebugMode ? 'development' : 'production';
    }, appRunner: () => runningMain(const MyApp(), AppColors.colors));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final allRoutes = {
      ...app_routes.appRoutes,
      ...game_routes.gameRoutes,
    };

    return RootWidget(
      homePath: allRoutes.keys.first,
      routes: allRoutes,
      splashImage: 'assets/images/splash.png',
      appColors: AppColors.colors,
      loading: ({text}) => Loading(
        loadingText: text ?? '正在加载...',
      ),
    );
  }
}
