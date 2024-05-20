import 'package:flutter/material.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';

class VolumeListener extends StatefulWidget {
  final Widget Function({required bool isMute}) child;

  const VolumeListener({Key? key, required this.child}) : super(key: key);

  @override
  VolumeListenerState createState() => VolumeListenerState();
}

class VolumeListenerState extends State<VolumeListener> {
  bool isMute = false;

  @override
  void initState() {
    super.initState();
    FlutterVolumeController.addListener(
      (volume) {
        debugPrint('Volume changed: $volume');
      },
    );
  }

  @override
  void dispose() {
    FlutterVolumeController.removeListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child(isMute: isMute);
  }
}
