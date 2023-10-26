import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/bottom_navigator_controller.dart';
import 'package:url_launcher/url_launcher.dart';

import '../apis/jingang_api.dart';
import '../enums/app_routes.dart';
import '../models/jingang_detail.dart';
import '../navigator/delegate.dart';

class JingangLinkButton extends StatelessWidget {
  final JinGangDetail? item;
  final Widget child;
  final JingangApi jingangApi = JingangApi();

  JingangLinkButton({required this.item, required this.child});
  final bottomNavigatorController = Get.find<BottomNavigatorController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        jingangApi.recordJingangClick(item?.id ?? 0);
        final url = item?.url;
        if (url == null) return;

        final Uri parsedUrl = Uri.parse(url);

        if (url.startsWith('http://') || url.startsWith('https://')) {
          // 狀況1: 如果item?.url為http://或https://開頭，則直接打開網頁
          launch(url, webOnlyWindowName: '_blank');
        } else if (parsedUrl.queryParameters.containsKey('defaultScreenKey')) {
          // 狀況2: 如果item?.url有 defaultScreenKey 這個query string，則跳轉到home
          final defaultScreenKey =
              Uri.parse(url).queryParameters['defaultScreenKey'];
          MyRouteDelegate.of(context).pushAndRemoveUntil(
            AppRoutes.home,
            hasTransition: false,
            args: {'defaultScreenKey': '/$defaultScreenKey'},
          );
          bottomNavigatorController.changeKey('/$defaultScreenKey');
        } else {
          final List<String> segments = parsedUrl.pathSegments;
          String path = '/${segments[0]}';
          if (segments.length == 2) {
            int id = int.parse(segments[1]);
            // 狀況3: 如果item?.url為 /{path}/{id}，則跳轉到該頁面並帶上id
            MyRouteDelegate.of(context).push(path, args: {'id': id});
          } else {
            // 狀況4: 如果item?.url為 /{path}，則跳轉到該頁面
            MyRouteDelegate.of(context).push(path);
          }
        }
      },
      child: Container(
        child: child,
      ),
    );
  }
}
