import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../navigator/delegate.dart';
import '../navigator/parser.dart';
import 'ad.dart';
import 'splash.dart';

typedef RouteObject = Map<String, WidgetBuilder>;

class RootWidget extends StatelessWidget {
  final String homePath;
  final RouteObject routes;
  final RouteObject baseRoutes = {
    '/': (context) => const Splash(),
    '/ad': (context) => const Ad(),
  };

  RootWidget({Key? key, required this.homePath, required this.routes})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      // routerConfig: router,
      routerDelegate: delegate,
      routeInformationParser: parser,
    );
  }
}
