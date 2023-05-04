import 'package:flutter/material.dart';

import 'short_card_info.dart';

class ShortCard extends StatelessWidget {
  final int index;
  const ShortCard({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Stack(
      children: [
        Center(
          child: Text(
            '視頻編號：${index + 1}',
            style: const TextStyle(
              fontSize: 24,
              color: Colors.white,
            ),
          ),
        ),
        ShortCardInfo(index: index)
      ],
    ));
  }
}
