import 'package:flutter/material.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:game/screens/game_withdraw_screen/turnover_content.dart';
import 'package:game/utils/showFormDialog.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class LabelWithStatus extends StatefulWidget {
  const LabelWithStatus({
    Key? key,
    required this.label,
    required this.reachable,
    required this.statusText,
    this.stakeLimit,
    this.validStake,
    this.withdrawalFee,
    this.leftIcon,
    this.rightIcon,
  }) : super(key: key);

  final String label;
  final bool reachable;
  final String statusText;
  final String? stakeLimit;
  final String? validStake;
  final double? withdrawalFee;
  final IconData? leftIcon;
  final IconData? rightIcon;

  @override
  LabelWithStatusState createState() => LabelWithStatusState();
}

class LabelWithStatusState extends State<LabelWithStatus> {
  _handleClickStatus() {
    showFormDialog(context, title: '', onClosed: () {
      Navigator.pop(context);
    },
        content: TurnOverContent(
          status: widget.reachable,
          statusText: widget.statusText,
          stakeLimit: widget.stakeLimit ?? '0.00',
          validStake: widget.validStake ?? '0.00',
          withdrawalFee: widget.withdrawalFee ?? 0.000,
        ));
  }

  @override
  Widget build(BuildContext context) {
    logger.i(' widget.stakeLimit, ${widget.stakeLimit}');
    logger.i(' widget.validStake, ${widget.validStake}');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (widget.leftIcon != null)
              Container(
                margin: const EdgeInsets.only(right: 2),
                width: 20,
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {},
                  child: Icon(
                    widget.leftIcon,
                    color: gameLobbyIconColor,
                  ),
                ),
              ),
            SizedBox(
              width: widget.leftIcon != null ? 70 : 100,
              child: Text(
                widget.label,
                style: const TextStyle(
                  color: Color(0xff979797),
                  fontSize: 14,
                ),
              ),
            ),
            Expanded(
              child: Wrap(
                spacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Icon(
                    widget.reachable ? Icons.check_circle : Icons.cancel,
                    color: widget.reachable ? Colors.green : Colors.red,
                    size: 14,
                  ),
                  GestureDetector(
                    onTap: () {
                      _handleClickStatus();
                    },
                    child: Text(
                      widget.statusText,
                      style: TextStyle(
                        color: widget.reachable ? Colors.green : Colors.red,
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (widget.rightIcon != null)
              Container(
                width: 20,
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    _handleClickStatus();
                  },
                  child: Icon(
                    widget.rightIcon,
                    color: gameLobbyIconColor,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 15),
        Container(height: 1, color: gameLobbyDividerColor),
      ],
    );
  }
}
