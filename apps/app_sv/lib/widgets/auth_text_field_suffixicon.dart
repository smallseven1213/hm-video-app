import 'package:app_sv/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/color_keys.dart';

class AuthTextFieldSuffixIcon extends StatefulWidget {
  final TextEditingController controller;

  const AuthTextFieldSuffixIcon({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  AuthTextFieldSuffixIconState createState() => AuthTextFieldSuffixIconState();
}

double newSize = 20;

class AuthTextFieldSuffixIconState extends State<AuthTextFieldSuffixIcon> {
  bool display = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      if (widget.controller.text.isEmpty) {
        setState(() {
          display = false;
        });
      } else {
        setState(() {
          display = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return display
        ? GestureDetector(
            onTap: () {
              widget.controller.clear();
            },
            child: SizedBox(
              width: newSize,
              height: newSize,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.colors[ColorKeys.textSecondary],
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.close,
                  size: newSize - 10,
                  color: Colors.white,
                ),
              ),
            ),
          )
        : const SizedBox();
  }
}
