import 'package:shared/utils/running_main.dart';
import 'config/colors.dart';
import 'widgets/loading.dart';
import './routes/app_routes.dart'
    if (dart.library.html) './routes/app_routes_web.dart' as app_routes;
import './routes/game_routes.dart' as game_routes;

void main() async {
  final allRoutes = {
    ...app_routes.appRoutes,
    ...game_routes.gameRoutes,
  };

  runningMain(
      'https://1b4441d1f4464b93a69208281ab77d4b@sentry.hmtech.site/2',
      allRoutes.keys.first,
      allRoutes,
      AppColors.colors,
      ({String? text}) => Loading(loadingText: text ?? '正在加载...'),
      null);
}
