import 'package:app_gp/pages/actor.dart';
import 'package:app_gp/screens/apps_screen/index.dart';
import 'package:app_gp/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/utils/runningMain.dart';
import 'package:shared/widgets/root.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'config/colors.dart';
import 'pages/collection.dart';
import 'pages/home.dart';
import 'pages/login.dart';
import 'pages/playrecord.dart';
import 'pages/register.dart';
import 'pages/share.dart';
import 'pages/sharerecord.dart';
import 'pages/tag_video.dart';
import 'pages/vendor_videos.dart';
import 'pages/video_by_block.dart';
import 'pages/favorites.dart';
import 'pages/filter.dart';
import 'pages/game/deposit.dart';
import 'pages/notifications.dart';
import 'pages/search.dart';
import 'pages/video.dart';

void main() {
  usePathUrlStrategy();
  runningMain(MyApp(), AppColors.colors);
}

final Map<String, RouteWidgetBuilder> routes = {
  AppRoutes.home.value: (context, args) => Home(),
  AppRoutes.video.value: (context, args) => Video(args: args),
  AppRoutes.videoByBlock.value: (context, args) => VideoByBlockPage(
        id: args['id'] as int,
        title: args['title'] as String,
        channelId: args['channelId'] as int,
      ),
  AppRoutes.vendorVideos.value: (context, args) => VendorVideosPage(
        id: args['id'] as int,
        title: args['title'] as String,
      ),
  AppRoutes.tag.value: (context, args) => TagVideoPage(
        id: args['id'] as int,
        title: args['title'] as String,
      ),
  AppRoutes.actor.value: (context, args) => ActorPage(
        id: args['id'] as int,
      ),
  AppRoutes.gameDeposit.value: (context, args) => const GameDeposit(),
  AppRoutes.login.value: (context, args) => LoginPage(),
  AppRoutes.register.value: (context, args) => RegisterPage(),
  AppRoutes.share.value: (context, args) => const SharePage(),
  AppRoutes.playRecord.value: (context, args) => PlayRecordPage(),
  AppRoutes.shareRecord.value: (context, args) => const ShareRecord(),
  AppRoutes.apps.value: (context, args) => const AppsScreen(),
  AppRoutes.favorites.value: (context, args) => FavoritesPage(),
  AppRoutes.collection.value: (context, args) => CollectionPage(),
  AppRoutes.notifications.value: (context, args) => const NotificationsPage(),
  AppRoutes.search.value: (context, args) => SearchPage(
        inputDefaultValue: args['inputDefaultValue'] as String,
        dontSearch: args['dontSearch'] as bool,
      ),
  AppRoutes.filter.value: (context, args) => const FilterPage(),
};

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RootWidget(
      homePath: routes.keys.first,
      routes: routes,
      splashImage: 'assets/images/splash.png',
      appColors: AppColors.colors,
      loading: ({text}) => Loading(
        loadingText: text ?? '正在加載...',
      ),
    );
  }
}
