import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:game/apis/game_api.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:game/utils/onLoading.dart';
import 'package:game/utils/showFormDialog.dart';
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
  if (kIsWeb) windowRef = html.window.open('', '_blank');
  await Future.delayed(const Duration(milliseconds: 66));
  try {
    var value = await GameLobbyApi().makeOrderV2(
      amount: amount,
      paymentChannelId: paymentChannelId,
      name: userName ?? '',
    );
    if (value.isNotEmpty && value.startsWith('http')) {
      if (kIsWeb) {
        await Future.delayed(const Duration(milliseconds: 500));
        // ignore: use_build_context_synchronously
        onLoading(context, status: false);
        // ignore: use_build_context_synchronously
        Navigator.pop(context); // 把驗證pin和真實姓名的dialog關掉
        windowRef?.location.href = value;
        // gto('/game/deposit/payment-result/0/$activePayment');
      } else {
        await launch(value, webOnlyWindowName: '_blank');
        // ignore: use_build_context_synchronously
        onLoading(context, status: false);
        // ignore: use_build_context_synchronously
        Navigator.pop(context); // 把驗證pin和真實姓名的dialog關掉
        // gto('/game/deposit/payment-result/0/$activePayment');
      }
    } else {
      // ignore: use_build_context_synchronously
      onLoading(context, status: false);
      // ignore: use_build_context_synchronously
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
          Navigator.popUntil(
              context, (route) => route.settings.name == '/game/deposit2'),
        },
      );
    }
  } catch (e) {
    // ignore: use_build_context_synchronously
    onLoading(context, status: false);
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
    print('_submitOrder error: $e');
  }
}
