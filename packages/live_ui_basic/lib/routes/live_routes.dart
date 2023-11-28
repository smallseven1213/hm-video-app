library live_routes;

import 'package:shared/navigator/delegate.dart';

import '../pages/live.dart';
import '../pages/live_room.dart';

final Map<String, RouteWidgetBuilder> liveRoutes = {
  "/live": (context, args) => const LivePage(),
  "/live_room": (context, args) => LiveRoomPage(
        pid: args['pid'] as int,
      ),
};
