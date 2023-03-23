import 'package:app_gp/pages/game/deposit.dart';
import 'package:app_gp/pages/video.dart';
import 'package:flutter/material.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/utils/runningMain.dart';
import 'package:shared/widgets/root.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'config/colors.dart';
import 'pages/home.dart';
import 'pages/login.dart';
import 'pages/register.dart';

void main() {
  usePathUrlStrategy();
  runningMain(MyApp(), AppColors.colors);
}

final Map<String, RouteWidgetBuilder> routes = {
  '/home': (context, args) => Home(),
  '/video': (context, args) => Video(args: args),
  '/game/deposit': (context, args) => const GameDeposit(),
  '/login': (context, args) => LoginPage(),
  '/register': (context, args) => RegisterPage(),
};

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RootWidget(
        homePath: routes.keys.first,
        routes: routes,
        splashImage: 'assets/images/splash.png',
        appColors: AppColors.colors);
  }
}
