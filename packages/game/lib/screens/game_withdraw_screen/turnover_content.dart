import 'package:flutter/material.dart';
import 'package:game/screens/game_theme_config.dart';

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
  _TurnOverContentState createState() => _TurnOverContentState();
}

class _TurnOverContentState extends State<TurnOverContent> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      child: Column(
        children: [
          // Column裡面依序放入以下
          // 1. 根據status顯示icon
          // 2. 文字"流水限額詳情"
          // 3. 放入一個row，水平排列spaceBetween
          // 4. row裡面放入兩個text，分別是"流水限額"和傳進來的金額
          // 5. row裡面放入一個text，"累積有效流水"和"和傳進來的金額
          // 放入一個divider
          // 最後放入文字"未達流水限額提現需支付提現手續費0.02%"
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
                '流水限額詳情',
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
                  '流水限額',
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
                  '累積有效流水',
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
            '未達流水限額提現需支付提現手續費 ${widget.withdrawalFee.toDouble() * 100} %',
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
