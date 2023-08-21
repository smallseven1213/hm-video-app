library app_routes;

import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';

import '../pages/home.dart' as home_page;
import '../pages/share.dart' as share_page;
import '../pages/collection.dart' as collection_page;
import '../pages/login.dart' as login_page;
import '../pages/register.dart' as register_page;

final Map<String, RouteWidgetBuilder> appRoutes = {
  AppRoutes.home: (context, args) => home_page.HomePage(
        defaultScreenKey: args['defaultScreenKey'] as String?,
      ),
  AppRoutes.share: (context, args) => const share_page.SharePage(),
  AppRoutes.collection: (context, args) =>
      const collection_page.CollectionPage(),
  AppRoutes.login: (context, args) => const login_page.LoginPage(),
  AppRoutes.register: (context, args) => const register_page.RegisterPage(),
};
