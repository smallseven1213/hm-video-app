import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class SidImageVisibilityDetector extends StatefulWidget {
  final Widget child;
  const SidImageVisibilityDetector({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  SidImageVisibilityDetectorState createState() =>
      SidImageVisibilityDetectorState();
}

class SidImageVisibilityDetectorState
    extends State<SidImageVisibilityDetector> {
  final _visibilityDetectorKey = GlobalKey();

  bool _isInViewport = kIsWeb ? false : true;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: _visibilityDetectorKey,
      onVisibilityChanged: (visibilityInfo) {
        if (kIsWeb && visibilityInfo.visibleFraction > 0.2) {
          setState(() {
            _isInViewport = true;
          });
        }
      },
      child: _isInViewport ? widget.child : const SizedBox.shrink(),
    );
  }
}
