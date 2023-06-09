import 'dart:math';
import 'package:flutter/material.dart';

final List<String> loadingTextList = [
  '檔案很大，你忍一下',
  '還沒準備好，你先悠著來',
  '精彩即將呈現',
  '努力加載中',
  '讓檔案載一會兒',
  '美好事物，值得等待',
  '拼命搬磚中',
];

class VideoListLoadingText extends StatefulWidget {
  const VideoListLoadingText({Key? key}) : super(key: key);

  @override
  VideoListLoadingTextState createState() => VideoListLoadingTextState();
}

class VideoListLoadingTextState extends State<VideoListLoadingText> {
  var rng = Random();
  var text = '';

  @override
  void initState() {
    setState(() {
      text = loadingTextList[rng.nextInt(loadingTextList.length)];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 15.0,
          width: 15.0,
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Color(0xFF486a89),
            ),
          ),
        ),
        const SizedBox(
            width: 8), // Add some space between the icon and the text
        Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF486a89),
          ),
        )
      ],
    );
  }
}
