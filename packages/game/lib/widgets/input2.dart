// create a custom input widget called "GameInput", that's inlucded label , textfield, and bottom border, tha't has alert message under the bottom border
import 'package:flutter/material.dart';
import 'package:game/screens/game_theme_config.dart';

class GameInput2 extends StatefulWidget {
  const GameInput2({
    Key? key,
    required this.label,
    required this.hint,
    required this.controller,
    this.field,
    this.errorMessage,
    this.onChanged,
    this.isPassword = false,
  }) : super(key: key);

  final String label;
  final String hint;
  final TextEditingController controller;
  final FormFieldState? field;
  final String? errorMessage;
  final Function? onChanged;
  final bool? isPassword;

  @override
  GameInputState createState() => GameInputState();
}

class GameInputState extends State<GameInput2> {
  bool obscureText = true;
  bool isPassword = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 120,
              child: Text(widget.label,
                  style:
                      const TextStyle(color: Color(0xff979797), fontSize: 14)),
            ),
            Expanded(
              child: TextField(
                controller: widget.controller,
                obscureText: isPassword ? obscureText : false,
                decoration: InputDecoration(
                  hintText: widget.hint,
                  hintStyle: TextStyle(color: gameLobbyLoginPlaceholderColor),
                  border: InputBorder.none,
                ),
                onChanged: (value) => widget.field!.didChange(value),
                style:
                    TextStyle(color: gameLobbyPrimaryTextColor, fontSize: 14),
                cursorColor: gameLobbyPrimaryTextColor,
              ),
            ),
            isPassword
                ? Container(
                    width: 16,
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          obscureText = !obscureText;
                        });
                      },
                      child: Icon(
                        obscureText ? Icons.visibility_off : Icons.visibility,
                        color: gameLobbyIconColor,
                        size: 16,
                      ),
                    ),
                  )
                : const SizedBox(),
            const SizedBox(width: 12),
            Container(
              width: 16,
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  widget.controller.clear();
                  widget.field!.reset();
                },
                child: Icon(
                  Icons.cancel,
                  color: gameLobbyIconColor,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
        Container(
          height: 1,
          color: widget.field!.hasError == true
              ? Colors.red
              : gameLobbyDividerColor,
        ),
        if (widget.field!.hasError)
          Text(
            widget.field!.errorText!,
            style: const TextStyle(color: Colors.red),
          ),
      ],
    );
  }
}
