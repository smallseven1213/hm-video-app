import 'package:flutter/material.dart';

class PurchaseButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;

  const PurchaseButton({
    Key? key,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: const Color.fromRGBO(19, 69, 165, 0.4),
        side: const BorderSide(color: Colors.blue),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        maximumSize: const Size(120, 50),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Colors.white),
      ), // 按鈕文字
    );
  }
}
