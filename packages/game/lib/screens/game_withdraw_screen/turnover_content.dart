import 'package:flutter/material.dart';
import 'package:game/screens/game_theme_config.dart';

import '../../localization/game_localization_delegate.dart';

class TurnOverContent extends StatefulWidget {
  const TurnOverContent({
    Key? key,
    required this.status,
    required this.statusText,
    required this.validStake,
    required this.stakeLimit,
    required this.withdrawalFee,
  }) : super(key: key);

  final bool status;
  final String statusText;
  final String validStake;
  final String stakeLimit;
  final double withdrawalFee;

  @override
  TurnOverContentState createState() => TurnOverContentState();
}

class TurnOverContentState extends State<TurnOverContent> {
  @override
  Widget build(BuildContext context) {
    final GameLocalizations localizations = GameLocalizations.of(context)!;

    var feeParse = (widget.withdrawalFee.toDouble() * 100)
        .toStringAsFixed(2)
        .replaceAll(RegExp(r'\.?0*$'), '');
    return SizedBox(
      height: 230,
      child: Column(
        children: [
          Icon(
            widget.status ? Icons.check_circle : Icons.cancel,
            color: widget.status ? Colors.green : Colors.red,
            size: 48,
          ),
          const SizedBox(height: 14),
          Text(
            widget.statusText,
            style: TextStyle(
              color: gameLobbyPrimaryTextColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.circle_outlined,
                color: gameLobbyHintColor,
                size: 8,
              ),
              const SizedBox(width: 5),
              Text(
                localizations.translate('flow_limit_details'),
                style: TextStyle(
                  color: gameLobbyPrimaryTextColor,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 13),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  localizations.translate('limit'),
                  style: TextStyle(
                    color: gameLobbyPrimaryTextColor,
                    fontSize: 14,
                  ),
                ),
                Text(
                  widget.stakeLimit.toString(),
                  style: TextStyle(
                    color: gameLobbyPrimaryTextColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(left: 13),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  localizations.translate('accumulated_liquidity'),
                  style: TextStyle(
                    color: gameLobbyPrimaryTextColor,
                    fontSize: 14,
                  ),
                ),
                Text(
                  widget.validStake.toString(),
                  style: TextStyle(
                    color: gameLobbyPrimaryTextColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Divider(
            color: gameLobbyDividerColor,
            height: 0,
            thickness: 1,
          ),
          const SizedBox(height: 10),
          Text(
            '${localizations.translate('withdrawal_fee_will_be_charged_for_withdrawal_before_reaching_the_limit')} $feeParse %',
            style: TextStyle(
              color: gameLobbyHintColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
