import 'package:flutter/material.dart';

class AuthTextFieldSuffixIcon extends StatefulWidget {
  final TextEditingController controller;

  const AuthTextFieldSuffixIcon({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  _AuthTextFieldSuffixIconState createState() =>
      _AuthTextFieldSuffixIconState();
}

double newSize = 20;

class _AuthTextFieldSuffixIconState extends State<AuthTextFieldSuffixIcon> {
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
        ? InkWell(
            onTap: () {
              widget.controller.clear();
            },
            child: SizedBox(
              width: newSize,
              height: newSize,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: const Color.fromRGBO(255, 255, 255, 0.3),
                      width: 1),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.close,
                  // Adjust the icon size accordingly
                  size: newSize - 10,
                  color: const Color.fromRGBO(255, 255, 255, 0.6),
                ),
              ),
            ),
          )
        : const SizedBox();
  }
}
