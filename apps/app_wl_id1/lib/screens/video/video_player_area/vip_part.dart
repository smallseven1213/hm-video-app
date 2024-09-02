import 'package:app_wl_id1/widgets/wave_loading.dart';
import 'package:flutter/material.dart';
import 'package:game/enums/game_app_routes.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared/controllers/bottom_navigator_controller.dart';
import 'package:shared/controllers/game_platform_config_controller.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/utils/event_bus.dart';
import 'package:shared/utils/goto_deposit.dart';
import 'package:shared/utils/video_info_formatter.dart';

import '../../../localization/i18n.dart';
import '../../../widgets/button.dart';

class VipPart extends StatelessWidget {
  final int timeLength;
  const VipPart({
    super.key,
    required this.timeLength,
  });

  @override
  Widget build(BuildContext context) {
    final bottomNavigatorController = Get.find<BottomNavigatorController>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          I18n.endOfTrialUpgradeToFullVersion,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          '${I18n.lengthOfFilm}：${getTimeString(timeLength)}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          I18n.unlockedForFullPlayback,
          style: const TextStyle(
            color: Color(0xffffd900),
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 15),
        // 開通VIP按鈕
        SizedBox(
          width: 175,
          height: 35,
          child: Button(
            text: I18n.upgradeNowForUnlock,
            size: 'small',
            onPressed: () {
              final bottomNavigatorController =
                  Get.find<BottomNavigatorController>();
              MyRouteDelegate.of(context).pushAndRemoveUntil(
                AppRoutes.home,
                args: {'defaultScreenKey': '/game'},
              );
              bottomNavigatorController.changeKey('/game');
              eventBus.fireEvent("gotoDepositAfterLogin");
            },
          ),
        ),
      ],
    );
  }
}
