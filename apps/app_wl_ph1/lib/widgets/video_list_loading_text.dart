import 'package:app_gs/localization/i18n.dart';
import 'dart:math';
import 'package:flutter/material.dart';

final List<String> loadingTextList = [
  I18n.itsABigFile,
  I18n.itsNotReadyYet,
  I18n.comingSoon,
  I18n.weAreTryingToLoadT,
  I18n.letTheFileLoadForAWhile,
  I18n.itsWorthWatingForTheGoodStuff,
  I18n.tryingToMoveBricks,
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
    super.initState();
    _updateLoadingText();
  }

  @override
  void didUpdateWidget(VideoListLoadingText oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateLoadingText();
  }

  void _updateLoadingText() {
    setState(() {
      text = loadingTextList[rng.nextInt(loadingTextList.length)];
    });
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
