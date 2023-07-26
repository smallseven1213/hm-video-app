import 'package:flutter/material.dart';
import 'package:shared/models/vod.dart';

class BlockOtherwiseWidget extends StatelessWidget {
  final List<Vod> videos;
  const BlockOtherwiseWidget({Key? key, required this.videos})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 200);
  }
}
