// BlockHeader is a stateless widget, return empty container

import 'package:flutter/material.dart';

class BlockHeader extends StatelessWidget {
  final String text;
  final Widget? moreButton;

  const BlockHeader({Key? key, required this.text, this.moreButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
