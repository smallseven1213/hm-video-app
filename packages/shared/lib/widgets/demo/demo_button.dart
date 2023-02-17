import 'package:flutter/material.dart';

class DemoButtonWidget extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const DemoButtonWidget({
    Key? key,
    required this.label,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(icon),
          const SizedBox(width: 8.0),
          Text(label),
        ],
      ),
    );
  }
}
