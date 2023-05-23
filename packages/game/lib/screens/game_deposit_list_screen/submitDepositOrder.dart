// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:game/apis/game_api.dart';
import 'package:game/enums/game_app_routes.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:game/utils/onLoading.dart';
import 'package:game/utils/showFormDialog.dart';
import 'package:get/get.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:universal_html/html.dart' as html;
import 'package:url_launcher/url_launcher.dart';

submitDepositOrder(
  BuildContext context, {
  required String amount,
  required int paymentChannelId,
  required String? userName,
  required String activePayment,
}) async {
  print(
      'amount: $amount, paymentChannelId: $paymentChannelId, userName: $userName');
  onLoading(context, status: true);
  // ignore: avoid_init_to_null
  var windowRef = null;
  if (GetPlatform.isWeb) windowRef = html.window.open('', '_blank');
  await Future.delayed(const Duration(milliseconds: 66));
  try {
    var value = await GameLobbyApi().makeOrderV2(
      amount: amount,
      paymentChannelId: paymentChannelId,
      name: userName ?? '',
    );
    if (value.isNotEmpty && value.startsWith('http')) {
      if (GetPlatform.isWeb) {
        await Future.delayed(const Duration(milliseconds: 500));
        onLoading(context, status: false);
        Navigator.pop(context); // 把驗證pin和真實姓名的dialog關掉
        windowRef?.location.href = value;
        MyRouteDelegate.of(context).push(GameAppRoutes.paymentResult.value);
        // gto('/game/deposit/payment-result/0/$activePayment');
      } else {
        await launch(value, webOnlyWindowName: '_blank');
        onLoading(context, status: false);
        Navigator.pop(context); // 把驗證pin和真實姓名的dialog關掉
        MyRouteDelegate.of(context).push(GameAppRoutes.paymentResult.value);
        // gto('/game/deposit/payment-result/0/$activePayment');
      }
    } else {
      onLoading(context, status: false);
      showFormDialog(
        context,
        title: '交易失敗',
        content: SizedBox(
          height: 24,
          child: Center(
            child: Text(
              value == '51728' ? '當前支付人數眾多，請稍後再試！' : '訂單建立失敗，請聯繫客服',
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
    showFormDialog(
      context,
      title: '_submitOrder error',
      content: SizedBox(
        height: 60,
        child: Text(
          e.toString(),
          style: TextStyle(color: gameLobbyPrimaryTextColor),
        ),
      ),
      confirmText: '確認',
      onConfirm: () => {
        Navigator.pop(context),
        Navigator.pop(context),
      },
    );
  }
}
