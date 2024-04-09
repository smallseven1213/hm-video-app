import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/game_platform_config_controller.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/bottom_navigator_controller.dart';
import '../navigator/delegate.dart';

final logger = Logger();

final bottomNavigatorController = Get.find<BottomNavigatorController>();

Map<int, String> gameDepositPage = {
  1: '/game/deposit_page_polling',
  2: '/game/deposit_page_list',
};

// 狀況1: 如果item?.url為http://或https://開頭，則直接打開網頁
void handleHttpUrl(String url) {
  launchUrl(Uri.parse(url), webOnlyWindowName: '_blank');
}

// 狀況2: 如果item?.url有 defaultScreenKey這個query string
// 拿到?之前的url，帶入route，再將defaultScreenKey帶入args
void handleDefaultScreenKey(BuildContext context, String url) {
  final defaultScreenKey = Uri.parse(url).queryParameters['defaultScreenKey'];
  final routePath = url.substring(0, url.indexOf('?'));
  final String gameId = Uri.parse(url).queryParameters['gameId'].toString();
  final String tpCode = Uri.parse(url).queryParameters['tpCode'].toString();

  if (gameId.isNotEmpty && gameId != '' && tpCode.isNotEmpty && tpCode != '') {
    GamePlatformConfigController gamePlatformConfigController =
        Get.find<GamePlatformConfigController>();
    gamePlatformConfigController.setThirdPartyGame(true, gameId, tpCode);
    MyRouteDelegate.of(context).push(
      '/home',
      args: {'defaultScreenKey': '/game'},
      removeSamePath: true,
    );
  } else {
    logger.i('url without gameId: $url');
    MyRouteDelegate.of(context).push(
      routePath,
      args: {'defaultScreenKey': '/$defaultScreenKey'},
      removeSamePath: true,
    );
  }

  bottomNavigatorController.changeKey('/$defaultScreenKey');
}

// 狀況3: 如果item?.url為 /{path}/{id}，則跳轉到該頁面並帶上id
// 狀況4: 如果item?.url為 /{path}，則跳轉到該頁面
void handlePathWithId(BuildContext context, String url) {
  final List<String> segments = Uri.parse(url).pathSegments;
  String path = '/${segments[0]}';
  if (segments.length == 2) {
    int id = int.parse(segments[1]);
    MyRouteDelegate.of(context).push(path, args: {'id': id});
  } else {
    MyRouteDelegate.of(context).push(path);
  }
}

// 狀況5: 如果包含depositType
void handleGameDepositType(BuildContext context, String url) {
  logger.i('url: $url');
  final depositType = Uri.parse(url).queryParameters['depositType'];
  MyRouteDelegate.of(context).push(
    gameDepositPage[int.parse(depositType!)].toString(),
    args: {'defaultScreenKey': '/game'},
    removeSamePath: true,
  );
  bottomNavigatorController.changeKey('/game');
}
