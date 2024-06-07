import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/bottom_navigator_controller.dart';
import 'package:shared/utils/handle_url.dart';
import 'package:shared/services/platform_service.app.dart'
    if (dart.library.html) 'package:shared/services/platform_service.web.dart'
    as app_platform_ervice;

import '../apis/jingang_api.dart';
import '../controllers/system_config_controller.dart';
import '../models/jingang_detail.dart';

class JingangLinkButton extends StatelessWidget {
  final JinGangDetail? item;
  final Widget child;
  final JingangApi jingangApi = JingangApi();

  JingangLinkButton({super.key, required this.item, required this.child});
  final bottomNavigatorController = Get.find<BottomNavigatorController>();
  final SystemConfigController systemConfigController =
      Get.find<SystemConfigController>();

  @override
  Widget build(BuildContext context) {
    print(
        '>>> systemConfigController.agentCode.value: ${app_platform_ervice.AppPlatformService().getHost()}');
    return GestureDetector(
      onTap: () async {
        jingangApi.recordJingangClick(item?.id ?? 0);
        var url = item?.url;
        if (url == null) return;
        // 替換 * 為代理碼
        url = url.replaceAll(
            '*', app_platform_ervice.AppPlatformService().getHost());
        print('>>> url: $url');
        final Uri parsedUrl = Uri.parse(url);

        if (url.startsWith('http://') || url.startsWith('https://')) {
          handleHttpUrl(url);
        } else if (parsedUrl.queryParameters.containsKey('depositType')) {
          handleGameDepositType(context, url);
        } else if (parsedUrl.queryParameters.containsKey('defaultScreenKey')) {
          handleDefaultScreenKey(context, url);
        } else {
          handlePathWithId(context, url);
        }
      },
      child: Container(
        child: child,
      ),
    );
  }
}
