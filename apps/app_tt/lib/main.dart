import 'package:app_tt/widgets/countdown.dart';
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
    'https://5975596ddf0f4a6b95b09de1adda3d53@sentry.hmtech.club/3',
    allRoutes.keys.first,
    [
      'https://dl.dlsv.net/$env/dl.json',
    ],
    allRoutes,
    AppColors.colors,
    ({String? text}) => Loading(loadingText: text ?? '正在加载...'),
    null,
    ({int countdownSeconds = 5}) =>
        Countdown(countdownSeconds: countdownSeconds),
  );
}
