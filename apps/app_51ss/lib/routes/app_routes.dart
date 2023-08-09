library app_routes;

import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';

import '../screens/demo.dart' as demo_screen;
import '../pages/home.dart' as home_page;

final Map<String, RouteWidgetBuilder> appRoutes = {
  AppRoutes.demo: (context, args) => const demo_screen.Demo(),
  AppRoutes.home: (context, args) => home_page.HomePage(
        defaultScreenKey: args['defaultScreenKey'] as String?,
      ),
};
