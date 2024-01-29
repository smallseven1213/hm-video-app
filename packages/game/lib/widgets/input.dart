import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game/screens/game_theme_config.dart';

class GameInput extends StatefulWidget {
  const GameInput({
    Key? key,
    required this.label,
    required this.hint,
    required this.controller,
    this.isFontBold = false,
    this.warningMessage,
    this.errorMessage,
    this.onChanged,
    this.isPassword = false,
    this.hasIcon,
    this.inputFormatters,
    this.focusNode,
    this.onClear,
  }) : super(key: key);

  final String label;
  final String hint;
  final TextEditingController controller;
  final bool isFontBold;
  final String? errorMessage;
  final String? warningMessage;
  final void Function(String value)? onChanged;
  final bool? isPassword;
  final Icon? hasIcon;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final Function()? onClear;

  @override
  GameInputState createState() => GameInputState();
}

class GameInputState extends State<GameInput> {
  bool obscureText = true;
  bool isPassword = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isPassword = widget.isPassword!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (widget.hasIcon != null)
              Container(
                margin: const EdgeInsets.only(right: 2),
                child: widget.hasIcon,
              ),
            SizedBox(
              width: widget.hasIcon != null ? 70 : 110,
              child: Text(
                widget.label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xff979797),
                  fontSize: 14,
                  fontWeight:
                      widget.isFontBold ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            Expanded(
              child: TextFormField(
                controller: widget.controller,
                obscureText: isPassword ? obscureText : false,
                decoration: InputDecoration(
                  hintText: widget.hint,
                  hintStyle: TextStyle(color: gameLobbyLoginPlaceholderColor),
                  border: InputBorder.none,
                ),
                onChanged: (value) => widget.onChanged!(value),
                style:
                    TextStyle(color: gameLobbyPrimaryTextColor, fontSize: 14),
                inputFormatters: widget.inputFormatters,
                cursorColor: gameLobbyPrimaryTextColor,
                focusNode: widget.focusNode,
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
                  widget.onClear!() ?? widget.controller.clear();
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
          color:
              widget.errorMessage != null ? Colors.red : gameLobbyDividerColor,
        ),
        if (widget.errorMessage != null)
          Text(
            widget.errorMessage!,
            style: const TextStyle(color: Colors.red, fontSize: 12),
          ),
        if (widget.warningMessage != null)
          Text(
            widget.warningMessage!,
            style: TextStyle(color: gameLobbyHintColor, fontSize: 12),
          ),
        const SizedBox(height: 5),
      ],
    );
  }
}
