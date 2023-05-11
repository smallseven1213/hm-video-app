import 'package:app_gs/pages/actor.dart';
import 'package:app_gs/pages/shorts_by_tag.dart';
import 'package:app_gs/screens/apps_screen/index.dart';
import 'package:app_gs/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/utils/runningMain.dart';
import 'package:shared/widgets/root.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'package:app_gs/screens/game_screen/lobby.dart';
import 'package:app_gs/screens/game_webview_screen/index.dart';
import 'package:app_gs/screens/game_withdraw_screen/index.dart';
import 'package:app_gs/screens/game_deposit_list_screen/index.dart';
import 'package:app_gs/screens/game_deposit_polling_screen/index.dart';
import 'package:app_gs/screens/game_payment_result_screen/index.dart';

import 'config/colors.dart';
import 'pages/actors.dart';
import 'pages/collection.dart';
import 'pages/home.dart';
import 'pages/login.dart';
import 'pages/playrecord.dart';
import 'pages/register.dart';
import 'pages/nickname.dart';
import 'pages/share.dart';
import 'pages/sharerecord.dart';
import 'pages/shorts_by_block.dart';
import 'pages/shorts_by_supplier.dart';
import 'pages/supplier.dart';
import 'pages/supplier_tag_video.dart';
import 'pages/tag_video.dart';
import 'pages/publisher.dart';
import 'pages/video_by_block.dart';
import 'pages/favorites.dart';
import 'pages/filter.dart';
import 'pages/notifications.dart';
import 'pages/search.dart';
import 'pages/video.dart';

void main() {
  usePathUrlStrategy();
  runningMain(const MyApp(), AppColors.colors);
}

final Map<String, RouteWidgetBuilder> routes = {
  AppRoutes.home.value: (context, args) => Home(),
  AppRoutes.video.value: (context, args) => Video(args: args),
  AppRoutes.videoByBlock.value: (context, args) => VideoByBlockPage(
        id: args['id'] as int,
        title: args['title'] as String,
        channelId: args['channelId'] as int,
      ),
  AppRoutes.publisher.value: (context, args) => PublisherPage(
        id: args['id'] as int,
        // title: args['title'] as String,
      ),
  AppRoutes.tag.value: (context, args) => TagVideoPage(
        key: ValueKey('tag-video-${args['id']}'),
        id: args['id'] as int,
        title: args['title'] as String,
      ),
  AppRoutes.actor.value: (context, args) => ActorPage(
        id: args['id'] as int,
      ),
  AppRoutes.gameLobby.value: (context, args) => const GameScreen(),
  AppRoutes.gameWebview.value: (context, args) => GameWebviewScreen(
        gameUrl: args['url'],
      ),
  AppRoutes.gameDepositList.value: (context, args) =>
      const GameDepositListScreen(),
  AppRoutes.gameDepositPolling.value: (context, args) =>
      const GameDepositPollingScreen(),
  AppRoutes.gameWithdraw.value: (context, args) => const GameWithdrawScreen(),
  AppRoutes.gamePaymentResult.value: (context, args) =>
      const GamePaymentResultScreen(),
  AppRoutes.login.value: (context, args) => LoginPage(),
  AppRoutes.nickname.value: (context, args) => NicknamePage(),
  AppRoutes.register.value: (context, args) => const RegisterPage(),
  AppRoutes.share.value: (context, args) => const SharePage(),
  AppRoutes.playRecord.value: (context, args) => PlayRecordPage(),
  AppRoutes.shareRecord.value: (context, args) => const ShareRecord(),
  AppRoutes.apps.value: (context, args) => const AppsScreen(),
  AppRoutes.favorites.value: (context, args) => const FavoritesPage(),
  AppRoutes.collection.value: (context, args) => CollectionPage(),
  AppRoutes.notifications.value: (context, args) => const NotificationsPage(),
  AppRoutes.search.value: (context, args) => SearchPage(
        inputDefaultValue: args['inputDefaultValue'] as String,
        dontSearch: args['dontSearch'] as bool,
      ),
  AppRoutes.filter.value: (context, args) => const FilterPage(),
  AppRoutes.actors.value: (context, args) => ActorsPage(),
  AppRoutes.supplier.value: (context, args) => SupplierPage(
        id: args['id'] as int,
      ),
  AppRoutes.supplierTag.value: (context, args) => SupplierTagVideoPage(
      tagId: args['tagId'] as int, tagName: args['tagName']),
  AppRoutes.shortsByTag.value: (context, args) => ShortsByTagPage(
        videoId: args['videoId'] as int,
        tagId: args['tagId'] as int,
      ),
  AppRoutes.shortsBySupplier.value: (context, args) => ShortsBySupplierPage(
        videoId: args['videoId'] as int,
        supplierId: args['supplierId'] as int,
      ),
  AppRoutes.shortsByBlock.value: (context, args) => ShortsByBlockPage(
        videoId: args['videoId'] as int,
        areaId: args['areaId'] as int,
      ),
};

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
