import 'package:app_ab/config/colors.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:shared/models/color_keys.dart';

class ListNoMore extends StatelessWidget {
  ListNoMore({Key? key}) : super(key: key);

  // 定义可能的文字
  final List<String> messages = [
    '顶到底了',
    '太深了客倌',
    '慢慢看，别这么挑',
    '花心已抵达',
    '确认过眼神，您是同道中人'
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
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.colors[ColorKeys.textSecondary],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
