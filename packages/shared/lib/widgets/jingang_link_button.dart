import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/bottom_navigator_controller.dart';
import 'package:shared/utils/handle_url.dart';

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
    return GestureDetector(
      onTap: () async {
        jingangApi.recordJingangClick(item?.id ?? 0);
        var url = item?.url;
        if (url == null) return;
        final Uri parsedUrl = Uri.parse(url);

        if (url.startsWith('http://') ||
            url.startsWith('https://') ||
            url.startsWith('*')) {
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
