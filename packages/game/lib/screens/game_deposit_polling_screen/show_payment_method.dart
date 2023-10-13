import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:game/screens/game_deposit_polling_screen/payment_method_item.dart';
import 'package:logger/logger.dart';

import 'package:game/apis/game_api.dart';
import 'package:game/models/game_payment.dart';
import 'package:game/screens/game_deposit_list_screen/show_user_name.dart';
import 'package:game/screens/game_deposit_polling_screen/payment_link_res.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:game/utils/show_form_dialog.dart';
import 'package:game/utils/show_model.dart';

final logger = Logger();
final GameLobbyApi gameLobbyApi = GameLobbyApi();

Future<void> showPaymentMethod({
  context,
  int productId = 0,
  String balanceFiatMoneyPrice = '',
  String name = '',
  Function? onClose,
}) async {
  int paymentMethod = 0;
  List<Payment> payments = await gameLobbyApi.getPaymentsBy(
      productId, balanceFiatMoneyPrice.split('.').first);
  if (payments.isNotEmpty) {
    paymentMethod = payments.first.id;
  } else {
    showFormDialog(
      context,
      title: '交易失敗',
      content: SizedBox(
        height: 24,
        child: Center(
          child: Text(
            payments == '51728' ? '當前支付人數眾多，請稍後再試！' : '訂單建立失敗，請聯繫客服',
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
    return;
  }

  await showModalBottomSheet(
    isDismissible: false,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      ),
    ),
    backgroundColor: gameLobbyBgColor,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (ctx, setModalState) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
              color: gameItemMainColor,
            ),
            height: (kIsWeb ? 160 : 190) + payments.length * 60,
            child: Column(
              children: [
                const SizedBox(height: 15),
                Stack(
                  children: [
                    Center(
                      child: Text(
                        "請選擇支付方式",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: gameLobbyAppBarTextColor),
                      ),
                    ),
                    Positioned(
                      right: 10,
                      top: -10,
                      child: InkWell(
                        onTap: () => Navigator.pop(ctx),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: Icon(
                            Icons.close,
                            color: gameLobbyAppBarTextColor,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 35),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.radio_button_unchecked_rounded,
                        size: 10,
                        color: gamePrimaryButtonColor,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      const Text("需支付金額",
                          style: TextStyle(
                              fontSize: 12, color: Color(0xff979797))),
                      Text(" ¥$balanceFiatMoneyPrice",
                          style:
                              const TextStyle(fontSize: 15, color: Colors.red)),
                    ],
                  ),
                ),
                Column(
                  children: [
                    ...payments
                        .where((product) => product.paymentType != '')
                        .map((payment) {
                      return PaymentMethodItem(
                        payment: payment,
                        paymentMethod: paymentMethod,
                        onPaymentSelected: (int selectedPayment) {
                          setModalState(() {
                            paymentMethod = selectedPayment;
                          });
                        },
                      );
                    }).toList(),
                  ],
                ),
                const SizedBox(height: 15),
                InkWell(
                  onTap: () async {
                    if (paymentMethod == 0) {
                      return;
                    }

                    // 如果選擇的paymentType為"銀行卡", 則要呼叫showUserNameDialog, 取得userName
                    if (payments
                            .firstWhere(
                                (element) => element.id == paymentMethod)
                            .paymentType ==
                        'debit') {
                      showUserName(
                        context,
                        onSuccess: (userName) => {
                          showModel(
                            context,
                            content: PaymentLinkRes(
                              productId: productId,
                              userName: userName,
                              paymentChannelId: paymentMethod,
                            ),
                          )
                        },
                      );
                    } else {
                      showModel(
                        context,
                        content: PaymentLinkRes(
                          productId: productId,
                          paymentChannelId: paymentMethod,
                          userName: null,
                        ),
                      );
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: gamePrimaryButtonColor,
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    child: Text('確認支付',
                        style: TextStyle(color: gamePrimaryButtonTextColor)),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  ).whenComplete(() {
    if (onClose != null) {
      onClose();
    }
  });
}
