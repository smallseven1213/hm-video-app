import 'package:flutter/material.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:game/screens/game_withdraw_screen/game_withdraw_field.dart';

import '../../localization/game_localization_deletate.dart';
import '../../models/user_withdrawal_data.dart';

class GameWithDrawOptionsBankCard extends StatelessWidget {
  const GameWithDrawOptionsBankCard({
    Key? key,
    required this.data,
    required this.onClick,
  }) : super(key: key);

  final UserPaymentSecurity data;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    final GameLocalizations localizations = GameLocalizations.of(context)!;

    return Container(
      // 背景為383d44, 圓角24, padding為上下14, 左右16
      decoration: BoxDecoration(
        color: gameLobbyBoxBgColor,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      child: Column(
        children: [
          // 白色的"帳戶資訊
          Text(
            localizations.translate('account_information'),
            style: TextStyle(color: gameLobbyPrimaryTextColor),
          ),
          Column(
            children: [
              GameWithDrawField(
                name: "銀行名稱",
                value: data.bankName ?? '',
              ),
              GameWithDrawField(
                name: "支行名稱",
                value: data.branchName ?? '',
              ),
              GameWithDrawField(
                name: "帳戶姓名",
                value: data.legalName ?? '',
              ),
              GameWithDrawField(
                name: "帳    戶",
                value: data.account ?? '',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
