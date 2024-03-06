library live_routes;

import 'package:shared/navigator/delegate.dart';

import '../pages/live.dart';
import '../pages/live_room.dart';
import '../pages/search.dart';
import '../pages/streamer_rank.dart';

final Map<String, RouteWidgetBuilder> liveRoutes = {
  "/live": (context, args) => const LivePage(),
  "/live_room": (context, args) => LiveRoomPage(
        pid: args['pid'] as int,
      ),
  "/streamer_rank": (context, args) => const StreamerRankPage(),
  "/live_search": (context, args) => const SearchPage(
      // query: args['query'] as String,
      ),
};
