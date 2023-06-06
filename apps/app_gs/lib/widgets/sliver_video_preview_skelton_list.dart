import 'dart:math';

import 'package:flutter/material.dart';

class SliverVideoPreviewSkeletonList extends StatelessWidget {
  final double imageRatio;

  SliverVideoPreviewSkeletonList({Key? key, this.imageRatio = 374 / 198})
      : super(key: key);

  final List<String> messages = [
    '檔案很大，你忍一下',
    '還沒準備好，你先悠著來',
    '精彩即將呈現',
    '努力加載中',
    '讓檔案載一會兒',
    '美好事物，值得等待',
    '拼命搬磚中'
  ];

  @override
  Widget build(BuildContext context) {
    final random = Random();
    final message = messages[random.nextInt(messages.length)];

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Center(
        child: SizedBox(
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(
                image: AssetImage('assets/images/list_no_more.png'),
                width: 20,
                height: 20,
              ),
              const SizedBox(
                  width: 8), // Add some space between the icon and the text
              Text(
                message, // Use the random message
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF486a89),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   // return SliverAlignedGrid.count(
  //   //   crossAxisCount: 2,
  //   //   itemCount: 6,
  //   //   itemBuilder: (BuildContext context, int index) {
  //   //     return VideoPreviewSkeleton();
  //   //   },
  //   //   mainAxisSpacing: 12.0,
  //   //   crossAxisSpacing: 10.0,
  //   // );
  //   return const SliverToBoxAdapter(
  //     child: Padding(
  //       padding: EdgeInsets.symmetric(vertical: 60),
  //       child: Center(
  //         child: Text(
  //           '更多影片讀取中...',
  //           style: TextStyle(color: Colors.white),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
