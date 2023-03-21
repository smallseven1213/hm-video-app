import 'package:flutter/material.dart';
import 'package:shared/models/color_keys.dart';
import '../navigator/delegate.dart';
import '../navigator/parser.dart';
import 'ad.dart';
import 'splash.dart';

typedef RouteObject = Map<String, WidgetBuilder>;

class RootWidget extends StatelessWidget {
  final String homePath;
  final RouteObject routes;
  final String splashImage;
  final Map<ColorKeys, Color> appColors;
  final MyRouteDelegate globalRouterDelegate;

  const RootWidget(
      {Key? key,
      required this.homePath,
      required this.routes,
      required this.splashImage,
      required this.appColors,
      required this.globalRouterDelegate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RouteObject baseRoutes = {
      '/': (context) => Splash(backgroundAssetPath: splashImage),
      '/ad': (context) => const Ad(),
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
