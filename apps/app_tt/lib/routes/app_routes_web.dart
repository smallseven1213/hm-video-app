library app_routes;

import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/widgets/page_loader.dart';

import '../pages/home.dart' deferred as home_page;
import '../widgets/page_loader.dart';

final Map<String, RouteWidgetBuilder> appRoutes = {
  AppRoutes.home: (context, args) => PageLoader(
        loadLibrary: home_page.loadLibrary,
        loadingWidget: const PageLoadingEffect(),
        createPage: () => home_page.HomePage(
          defaultScreenKey: args['defaultScreenKey'] as String?,
        ),
      ),
};
