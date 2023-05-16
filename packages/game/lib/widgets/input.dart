import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game/screens/game_theme_config.dart';

class GameInput extends StatefulWidget {
  const GameInput({
    Key? key,
    required this.label,
    required this.hint,
    required this.controller,
    this.warningMessage,
    this.errorMessage,
    this.onChanged,
    this.isPassword = false,
    this.hasIcon,
    this.inputFormatters,
  }) : super(key: key);

  final String label;
  final String hint;
  final TextEditingController controller;
  final String? errorMessage;
  final String? warningMessage;
  final Function? onChanged;
  final bool? isPassword;
  final Icon? hasIcon;
  final List<TextInputFormatter>? inputFormatters;

  @override
  _GameInputState createState() => _GameInputState();
}

class _GameInputState extends State<GameInput> {
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
              width: widget.hasIcon != null ? 70 : 100,
              child: Text(
                widget.label,
                style: const TextStyle(
                  color: Color(0xff979797),
                  fontSize: 14,
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
              ),
            ),
            isPassword
                ? Container(
                    width: 14,
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
                      ),
                    ),
                  )
                : const SizedBox(),
            Container(
              width: 20,
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  widget.controller.clear();
                },
                child: Icon(
                  Icons.cancel,
                  color: gameLobbyIconColor,
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
