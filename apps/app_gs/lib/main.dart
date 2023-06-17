import 'package:app_gs/widgets/loading.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared/services/system_config.dart';
import 'package:shared/utils/running_main.dart';
import 'package:shared/widgets/root.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'config/colors.dart';

import './routes/app_routes.dart' deferred as app_routes;
import './routes/game_routes.dart' deferred as game_routes;

void main() async {
  usePathUrlStrategy();

  await SentryFlutter.init((options) {
    options.dsn =
        'https://1b4441d1f4464b93a69208281ab77d4b@sentry.hmtech.site/2';
    // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
    // We recommend adjusting this value in production.
    options.tracesSampleRate = 1.0;
    options.release = SystemConfig().version;
    options.environment = kDebugMode ? 'development' : 'production';
  }, appRunner: () => runningMain(const MyApp(), AppColors.colors));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // 这个函数负责加载 app_routes 模块
  Future<void> _loadAppRoutes() => app_routes.loadLibrary();

  // 这个函数负责加载 game_routes 模块
  Future<void> _loadGameRoutes() => game_routes.loadLibrary();

  @override
  Widget build(BuildContext context) {
    _loadAppRoutes();
    _loadGameRoutes();

    return FutureBuilder(
      // 等待两个模块都加载完毕
      future: Future.wait([_loadAppRoutes(), _loadGameRoutes()]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // 合并 app_routes 和 game_routes
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
              loadingText: text ?? '正在加載...',
            ),
          );
        } else {
          // 显示 loading 指示器，直到模块加载完毕
          return const MaterialApp(home: SizedBox.shrink());
        }
      },
    );
  }
}
