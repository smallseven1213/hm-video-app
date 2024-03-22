import 'package:app_wl_ph1/localization/i18n.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class ListNoMore extends StatelessWidget {
  ListNoMore({Key? key}) : super(key: key);

  // 定义可能的文字
  final List<String> messages = [
    I18n.theTopIsDown,
    I18n.itsTooDeepMaam,
    I18n.takeYourTimeDontBeSoPicky,
    I18n.iveReachedTheCenterOfMyHeart,
    I18n.imSureYourAreTheSameKindOfMe
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
}
