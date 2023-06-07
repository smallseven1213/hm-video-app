import 'package:app_gs/screens/video/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:shared/apis/user_api.dart';

final logger = Logger();

final userApi = UserApi();

class Video extends StatefulWidget {
  final Map<String, dynamic> args;

  const Video({Key? key, required this.args}) : super(key: key);

  @override
  VideoState createState() => VideoState();
}

class VideoState extends State<Video> {
  @override
  void initState() {
    super.initState();
    userApi.addPlayHistory(widget.args['id']);
    // setScreenRotation();
  }

  @override
  void dispose() {
    // setScreenPortrait();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    logger.i('RENDER VIDEO ${widget.args['id']}');
    return VideoScreen(
      key: ValueKey(widget.args['id']),
      id: int.parse(widget.args['id'].toString()),
      name: widget.args['name'],
    );
  }
}
