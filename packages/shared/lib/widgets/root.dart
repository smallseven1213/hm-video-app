import 'package:flutter/material.dart';
import 'package:game/widgets/game_startup.dart';
import 'package:get/get.dart';
import 'package:shared/models/color_keys.dart';
import '../enums/app_routes.dart';
import '../navigator/delegate.dart';
import '../navigator/parser.dart';
import 'ad.dart';
import 'splash.dart';

typedef RouteObject = Map<String, RouteWidgetBuilder>;

class RootWidget extends StatelessWidget {
  final String homePath;
  final RouteObject routes;
  final String splashImage;
  final Map<ColorKeys, Color> appColors;
  final Function? loading;

  const RootWidget({
    Key? key,
    required this.homePath,
    required this.routes,
    required this.splashImage,
    required this.appColors,
    this.loading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RouteObject baseRoutes = {
      '/': (context, args) =>
          Splash(backgroundAssetPath: splashImage, loading: loading),
      '/ad': (context, args) =>
          Ad(backgroundAssetPath: splashImage, loading: loading),
    };

    final delegate = MyRouteDelegate(
      homePath: homePath,
      routes: {...baseRoutes, ...routes},
      // onGenerateRoute: (RouteSettings settings) {
      //   return MaterialPageRoute(
      //     settings: settings,
      //     builder: (BuildContext context) {
      //       return Splash();
      //     },
      //   );
      // },
    );

    final parser = MyRouteParser();

    return MaterialApp.router(
      routerDelegate: delegate,
      routeInformationParser: parser,
      theme: ThemeData(
        scaffoldBackgroundColor: appColors[ColorKeys.background],
      ),
    );
  }
}
