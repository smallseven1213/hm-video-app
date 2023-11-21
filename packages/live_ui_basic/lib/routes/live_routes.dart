library live_routes;

import 'package:shared/navigator/delegate.dart';

import '../pages/live.dart';

final Map<String, RouteWidgetBuilder> liveRoutes = {
  "/live": (context, args) => LivePage(),
};
