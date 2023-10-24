import 'package:app_tt/widgets/countdown.dart';
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
    'https://da90e5b7def842619c300395450aeb77@sentry.hmtech.club/7',
    allRoutes.keys.first,
    [
      'https://dl.dlsv.net/$env/dl.json',
    ],
    allRoutes,
    AppColors.colors,
    ({String? text}) => Loading(loadingText: text ?? I18n.loadingNow),
    null,
    ({int countdownSeconds = 5}) =>
        Countdown(countdownSeconds: countdownSeconds),
    i18nSupport: true,
    supportedLocales: I18n.supportedLocales,
    i18nPath: 'assets/langs/langs.csv',
  );
}
