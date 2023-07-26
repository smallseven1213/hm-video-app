import 'package:flutter/material.dart';
import 'package:shared/models/vod.dart';

class Block11Widget extends StatelessWidget {
  final List<Vod> videos;
  const Block11Widget({Key? key, required this.videos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        padding: const EdgeInsets.all(10),
        children: List.generate(
            10,
            (index) => Container(
                  width: double.infinity,
                  height: 60,
                  color: Colors.white,
                )));
  }
}
