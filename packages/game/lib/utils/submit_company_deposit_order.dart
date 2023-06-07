// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:game/apis/game_api.dart';
import 'package:game/enums/game_app_routes.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:game/utils/on_loading.dart';
import 'package:game/utils/show_form_dialog.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/navigator/delegate.dart';

final logger = Logger();

submitCompanyDepositOrder(
  BuildContext context, {
  required String amount,
  required int paymentChannelId,
  required String remark,
}) async {
  onLoading(context, status: true);
  await Future.delayed(const Duration(milliseconds: 66));
  try {
    var res = await Get.find<GameLobbyApi>().companyOrderDeposit(
      amount,
      paymentChannelId,
      remark,
    );
    logger.i('companyOrderDeposit res: $res');
    if (res['code'] == '00') {
      onLoading(context, status: false);
      MyRouteDelegate.of(context).push(GameAppRoutes.paymentResult.value);
    } else {
      onLoading(context, status: false);
      showFormDialog(
        context,
        title: '交易失敗',
        content: SizedBox(
          height: 24,
          child: Center(
            child: Text(
              res['message'],
              style: TextStyle(color: gameLobbyPrimaryTextColor),
            ),
          ),
        ),
        confirmText: '確認',
        onConfirm: () => {
          Navigator.pop(context),
          Navigator.pop(context),
        },
      );
    }
  } catch (e) {
    onLoading(context, status: false);
    Navigator.pop(context);
    logger.i('_submitCompanyDepositOrder error: $e');
  }
}
