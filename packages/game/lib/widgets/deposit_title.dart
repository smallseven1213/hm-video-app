import 'package:flutter/material.dart';
import 'package:game/screens/game_theme_config.dart';

class DepositTitle extends StatefulWidget {
  final String title;
  const DepositTitle({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  DepositTitleState createState() => DepositTitleState();
}

class DepositTitleState extends State<DepositTitle> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // a circle graphic, it has back background, and has a border ebfe69
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            border: Border.fromBorderSide(
              BorderSide(
                color: gamePrimaryButtonColor,
                width: 1,
              ),
            ),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          widget.title,
          style: TextStyle(
            color: gameLobbyPrimaryTextColor,
            fontSize: 12,
            fontWeight: FontWeight.w200,
          ),
        ),
      ],
    );
  }
}
