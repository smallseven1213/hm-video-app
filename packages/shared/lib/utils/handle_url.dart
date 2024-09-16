import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/game_platform_config_controller.dart';
import 'package:shared/services/platform_service.app.dart'
    if (dart.library.html) 'package:shared/services/platform_service.web.dart'
    as app_platform_ervice;
import 'package:shared/utils/event_bus.dart';
import 'package:shared/utils/handle_game_url_methods.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/bottom_navigator_controller.dart';
import '../navigator/delegate.dart';

final logger = Logger();

final bottomNavigatorController = Get.find<BottomNavigatorController>();
GamePlatformConfigController gamePlatformConfigController =
    Get.find<GamePlatformConfigController>();

// 狀況1: 如果item?.url為http://或https://開頭，則直接打開網頁
void handleHttpUrl(String url) {
  url = url.replaceAll(
      '*', 'https://${app_platform_ervice.AppPlatformService().getHost()}');
  launchUrl(Uri.parse(url), webOnlyWindowName: '_blank');
}

// 狀況2:
// 先區分defaultScreenKey是否為game，如果是則執行handleGameUrlMethods
// url = /home?defaultScreenKey=game執行MyRouteDelegate前往遊戲大廳
// 其餘情況執行MyRouteDelegate
void handleDefaultScreenKey(BuildContext context, String url) {
  final defaultScreenKey = Uri.parse(url).queryParameters['defaultScreenKey'];
  final routePath = url.substring(0, url.indexOf('?'));

  // get current path
  final currentPath = MyRouteDelegate.of(context).currentPath;

  if (currentPath == routePath && currentPath == "/home") {
    bottomNavigatorController.changeKey('/$defaultScreenKey');
  } else if (defaultScreenKey == 'game') {
    handleGameUrlMethods(context, url, routePath);
  } else {
    MyRouteDelegate.of(context).push(
      routePath,
      args: {'defaultScreenKey': '/$defaultScreenKey'},
      removeSamePath: true,
    );

    bottomNavigatorController.changeKey('/$defaultScreenKey');
  }
}

// 狀況3: 如果item?.url為 /{path}/{id}，則跳轉到該頁面並帶上id
// 狀況4: 如果item?.url為 /{path}，則跳轉到該頁面
void handlePathWithId(
  BuildContext context,
  String url, {
  removeSamePath = false,
}) {
  final List<String> segments = Uri.parse(url).pathSegments;
  String path = '/${segments[0]}';
  if (segments.length == 2) {
    int id = int.parse(segments[1]);
    MyRouteDelegate.of(context)
        .push(path, args: {'id': id}, removeSamePath: removeSamePath);
  } else {
    MyRouteDelegate.of(context).push(path);
  }
}

// 狀況5: 如果包含depositType
void handleGameDepositType(BuildContext context, String url) {
  logger.i('url: $url');
  eventBus.fireEvent("gotoDepositAfterLogin");
  bottomNavigatorController.changeKey('/game');
}
