import 'package:flutter/material.dart';

class PaySwitchButton extends StatelessWidget {
  const PaySwitchButton({
    Key? key,
    required this.leftChild,
    required this.rightChild,
  }) : super(key: key);

  final Widget leftChild;
  final Widget rightChild;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          leftChild,
          rightChild,
        ],
      ),
    );
  }
}
