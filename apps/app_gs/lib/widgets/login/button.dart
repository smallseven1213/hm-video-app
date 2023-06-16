import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  final Icon? icon;
  final String? type; // primary, secondary
  final String? size; // small, medium, large

  const LoginButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.type = 'primary',
    this.size = 'medium',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 1, color: Colors.white),
        color: type == 'primary'
            ? const Color.fromARGB(255, 161, 184, 226)
            : const Color(0xff1E50B1),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          clipBehavior: Clip.antiAlias,
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: type == 'primary'
                    ? const Color(0xFF4277DC)
                    : const Color.fromRGBO(18, 18, 69, 0.5),
                blurRadius: 20,
                spreadRadius: type == 'primary' ? 0 : -10,
              ),
            ],
          ),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
