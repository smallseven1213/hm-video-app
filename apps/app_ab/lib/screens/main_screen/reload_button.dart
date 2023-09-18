import 'package:flutter/material.dart';

class ReloadButton extends StatelessWidget {
  final Function? onPressed;
  const ReloadButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('輸入異常',
            style: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.3))),
        const Text('請重新加載',
            style: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.3))),
        IconButton(
          onPressed: () => onPressed!(),
          icon: const Icon(
            Icons.refresh,
            color: Color.fromRGBO(255, 255, 255, 0.3),
            size: 22,
          ),
        ),
      ],
    );
  }
}
