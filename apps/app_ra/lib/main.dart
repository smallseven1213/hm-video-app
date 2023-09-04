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
      'https://45f8d2078d0f48a2ad32be194630b9f6@sentry.hmtech.club/5',
      allRoutes.keys.first,
      [
        'https://dl.dlsv.net/$env/dl.json',
      ],
      allRoutes,
      AppColors.colors,
      ({String? text}) => Loading(loadingText: text ?? '正在加载...'),
      null,
      null);
}
