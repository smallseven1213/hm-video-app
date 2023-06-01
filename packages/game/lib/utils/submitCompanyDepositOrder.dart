// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:game/apis/game_api.dart';
import 'package:game/enums/game_app_routes.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:game/utils/onLoading.dart';
import 'package:game/utils/showFormDialog.dart';
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
    logger.i('value: $res');
    if (res.isNotEmpty) {
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
              '當前支付人數眾多，請稍後再試',
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
    print('_submitCompanyDepositOrder error: $e');
  }
}
