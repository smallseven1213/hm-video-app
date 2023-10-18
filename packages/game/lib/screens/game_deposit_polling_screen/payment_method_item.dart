import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'package:game/models/game_payment.dart';
import 'package:game/models/game_payment_channel_detail.dart';
import 'package:game/screens/game_theme_config.dart';

final logger = Logger();

class PaymentMethodItem extends StatelessWidget {
  final Payment payment;
  final int paymentMethod;
  final void Function(int) onPaymentSelected;

  const PaymentMethodItem({
    super.key,
    required this.payment,
    required this.paymentMethod,
    required this.onPaymentSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5, left: 24, right: 24),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: gameLobbyDividerColor,
            width: 1,
          ),
        ),
      ),
      child: InkWell(
        onTap: () {
          onPaymentSelected(payment.id);
        },
        child: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              if (payment.paymentType!.isNotEmpty &&
                  payment.paymentType != '' &&
                  paymentsMapper[payment.paymentType] != null)
                Image.asset(
                  paymentsMapper[payment.paymentType]!['icon'].toString(),
                  width: 20,
                  height: 20,
                ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: Text(
                  payment.paymentTypeName ?? '',
                  style: TextStyle(
                    color: gameLobbyPrimaryTextColor,
                  ),
                ),
              ),
              Checkbox(
                activeColor: const Color(0xff0bb563),
                checkColor: gameLobbyBgColor,
                value: paymentMethod == payment.id,
                onChanged: (val) {
                  if (val == true) {
                    onPaymentSelected(payment.id);
                  }
                },
                side: MaterialStateBorderSide.resolveWith(
                  (states) => BorderSide.none,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(64.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
