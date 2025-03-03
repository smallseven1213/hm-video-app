import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'package:game/apis/game_api.dart';
import 'package:game/models/game_payment.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:game/screens/game_deposit_list_screen/show_user_name.dart';
import 'package:game/screens/game_deposit_polling_screen/payment_link_res.dart';
import 'package:game/screens/game_deposit_polling_screen/payment_method_item.dart';
import 'package:game/utils/show_form_dialog.dart';
import 'package:game/utils/show_model.dart';

import '../../localization/game_localization_delegate.dart';

final logger = Logger();
final GameLobbyApi gameLobbyApi = GameLobbyApi();

Future<void> showPaymentMethod({
  context,
  required amount,
  Function? onClose,
}) async {
  int paymentMethod = 0;
  List<Payment> payments = await gameLobbyApi.getPaymentsBy(amount.toString());
  if (payments.isNotEmpty) {
    paymentMethod = payments.first.id;
  } else {
    showFormDialog(
      context,
      title: GameLocalizations.of(context)!.translate('transaction_failed'),
      content: SizedBox(
        height: 24,
        child: Center(
          child: Text(
            GameLocalizations.of(context)!.translate(
                'order_creation_failed_please_contact_our_customer_service'),
            style: TextStyle(color: gameLobbyPrimaryTextColor),
          ),
        ),
      ),
      confirmText: GameLocalizations.of(context)!.translate('confirm'),
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
      final GameLocalizations localizations = GameLocalizations.of(context)!;

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
            height: (kIsWeb ? 150 : 190) + payments.length * 55,
            child: Column(
              children: [
                const SizedBox(height: 15),
                Stack(
                  children: [
                    Center(
                      child: Text(
                        localizations.translate('please_select_payment_method'),
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
                  margin: const EdgeInsets.only(
                      top: 10, bottom: 5, left: 35, right: 35),
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
                      Text(localizations.translate('amount_to_be_paid'),
                          style: const TextStyle(
                              fontSize: 12, color: Color(0xff979797))),
                      Text("$amount ${localizations.translate('dollar')}",
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
                const SizedBox(height: 5),
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
                              amount: amount.toString(),
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
                          amount: amount.toString(),
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
                    child: Text(localizations.translate('confirm_payment'),
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
