// paymentPage:2 列表
import 'package:flutter/material.dart';
import 'package:game/screens/game_deposit_detail_screen/index.dart';

class GameDepositDetailScreen extends StatelessWidget {
  final String payment;
  final int paymentChannelId;

  const GameDepositDetailScreen(
      {Key? key, required this.payment, required this.paymentChannelId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GameDepositDetail(
        payment: payment, paymentChannelId: paymentChannelId);
  }
}
