import 'package:app_gs/pages/actor.dart';
import 'package:app_gs/pages/configs.dart';
import 'package:app_gs/pages/shorts_by_local.dart';
import 'package:app_gs/pages/shorts_by_tag.dart';
import 'package:app_gs/screens/apps_screen/index.dart';
import 'package:app_gs/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:game/enums/game_app_routes.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/utils/runningMain.dart';
import 'package:shared/widgets/root.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'package:app_gs/screens/games/game_lobby_screen/lobby.dart';
import 'package:app_gs/screens/games/game_webview_screen/index.dart';
import 'package:app_gs/screens/games/game_withdraw_screen/index.dart';
import 'package:app_gs/screens/games/game_set_fundpassword_screen/index.dart';
import 'package:app_gs/screens/games/game_set_bankcard_screen/index.dart';
import 'package:app_gs/screens/games/game_deposit_list_screen/index.dart';
import 'package:app_gs/screens/games/game_deposit_polling_screen/index.dart';
import 'package:app_gs/screens/games/game_deposit_detail_screen/index.dart';
import 'package:app_gs/screens/games/game_payment_result_screen/index.dart';
import 'package:app_gs/screens/games/game_deposit_record_screen/index.dart';
import 'package:app_gs/screens/games/game_withdraw_record_screen/index.dart';

import 'config/colors.dart';
import 'pages/actors.dart';
import 'pages/collection.dart';
import 'pages/home.dart';
import 'pages/id.dart';
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
import 'pages/update_password.dart';
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
  AppRoutes.home.value: (context, args) => HomePage(
        defaultScreenKey: args['defaultScreenKey'] as String?,
      ),
  AppRoutes.video.value: (context, args) => Video(args: args),
  AppRoutes.videoByBlock.value: (context, args) => VideoByBlockPage(
        blockId: args['blockId'] as int,
        title: args['title'] as String,
        channelId: args['channelId'] as int,
        film: args['film'] == null ? 1 : args['film'] as int,
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
  GameAppRoutes.lobby.value: (context, args) => const GameScreen(),
  GameAppRoutes.webview.value: (context, args) => GameWebviewScreen(
        gameUrl: args['url'],
      ),
  GameAppRoutes.depositList.value: (context, args) =>
      const GameDepositListScreen(),
  GameAppRoutes.depositPolling.value: (context, args) =>
      const GameDepositPollingScreen(),
  GameAppRoutes.depositDetail.value: (context, args) => GameDepositDetailScreen(
        payment: args['payment'] as String,
        paymentChannelId: args['paymentChannelId'] as int,
      ),
  GameAppRoutes.withdraw.value: (context, args) => const GameWithdrawScreen(),
  GameAppRoutes.setFundPassword.value: (context, args) =>
      const GameSetFundPasswordScreen(),
  GameAppRoutes.setBankcard.value: (context, args) =>
      const GameSetBankCardScreen(),
  GameAppRoutes.paymentResult.value: (context, args) =>
      const GamePaymentResultScreen(),
  GameAppRoutes.depositRecord.value: (context, args) =>
      const GameDepositRecordScreen(),
  GameAppRoutes.withdrawRecord.value: (context, args) =>
      const GameWithdrawRecordScreen(),
  AppRoutes.login.value: (context, args) => LoginPage(),
  AppRoutes.nickname.value: (context, args) => NicknamePage(),
  AppRoutes.register.value: (context, args) => const RegisterPage(),
  AppRoutes.share.value: (context, args) => const SharePage(),
  AppRoutes.playRecord.value: (context, args) => const PlayRecordPage(),
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
  AppRoutes.shortsByLocal.value: (context, args) => ShortsByLocalPage(
        videoId: args['videoId'] as int,
        itemId: args['itemId'] as int,
      ),
  AppRoutes.configs.value: (context, args) => ConfigsPage(),
  AppRoutes.updatePassword.value: (context, args) => const UpdatePasswordPage(),
  AppRoutes.idCard.value: (context, args) => const IDCardPage(),
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
