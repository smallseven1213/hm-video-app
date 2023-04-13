import 'package:app_gp/screens/video/video_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:shared/apis/user_api.dart';

final logger = Logger();

final userApi = UserApi();

class Video extends StatefulWidget {
  // props: args
  final Map<String, dynamic> args;

  Video({Key? key, required this.args}) : super(key: key);

  @override
  _VideoState createState() => _VideoState();
}

class _VideoState extends State<Video> {
  @override
  void initState() {
    super.initState();
    userApi.addPlayHistory(widget.args['id']);
    // Allow screen rotation when entering the page
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    // Restore original orientations when leaving the page
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VideoScreen(
      key: ValueKey(widget.args['id']),
      id: int.parse(widget.args['id'].toString()),
      name: widget.args['name'],
    );
  }
}
