import 'package:app_gp/pages/game/deposit.dart';
import 'package:app_gp/pages/video.dart';
import 'package:app_gp/screens/apps_screen/index.dart';
import 'package:flutter/material.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/utils/runningMain.dart';
import 'package:shared/widgets/root.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'config/colors.dart';
import 'pages/home.dart';
import 'pages/login.dart';
import 'pages/myfav.dart';
import 'pages/playrecord.dart';
import 'pages/register.dart';
import 'pages/share.dart';
import 'pages/sharerecord.dart';
import 'pages/video_by_block.dart';

void main() {
  usePathUrlStrategy();
  runningMain(MyApp(), AppColors.colors);
}

final Map<String, RouteWidgetBuilder> routes = {
  '/home': (context, args) => Home(),
  '/video': (context, args) => Video(args: args),
  '/video_by_block': (context, args) => VideoByBlockPage(
        id: args['id'] as int,
        title: args['title'] as String,
        channelId: args['channelId'] as int,
      ),
  '/game/deposit': (context, args) => const GameDeposit(),
  '/login': (context, args) => LoginPage(),
  '/register': (context, args) => RegisterPage(),
  '/share': (context, args) => const SharePage(),
  '/playrecord': (context, args) => PlayRecordPage(),
  '/sharerecord': (context, args) => const ShareRecord(),
  '/myfavorite': (context, args) => const MyFavoritesPage(),
  '/apps': (context, args) => const AppsScreen(),
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
