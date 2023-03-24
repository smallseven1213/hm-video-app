import 'package:app_gp/screens/video/video_screen.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class Video extends StatefulWidget {
  // props: args
  final Map<String, dynamic> args;

  Video({Key? key, required this.args}) : super(key: key);

  @override
  _VideoState createState() => _VideoState();
}

class _VideoState extends State<Video> {
  @override
  Widget build(BuildContext context) {
    logger.i(widget.args);
    return VideoScreen(id: int.parse(widget.args['id'].toString()));
  }
}
