// BlockHeader is a stateless widget, return empty container

import 'package:flutter/material.dart';

class BlockHeader extends StatelessWidget {
  final String text;
  final Widget? moreButton;

  const BlockHeader({Key? key, required this.text, this.moreButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (text == "") {
      return Container();
    } else {
      return Padding(
        padding: const EdgeInsets.only(left: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  height: 15,
                  width: 2,
                  color: const Color(0xFFFF3B52),
                ),
                const SizedBox(width: 8),
                Text(
                  text,
                  style: const TextStyle(
                    color: Color(0xFF161823),
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            moreButton ?? Container(),
          ],
        ),
      );
    }
  }
}
