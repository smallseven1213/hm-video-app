// ignore_for_file: library_prefixes

import 'package:flutter/material.dart';
// if dart:html is available, import the web version of the widget
import 'h5webview_app.dart' if (dart.library.html) 'h5webview_web.dart';

class H5Webview extends StatelessWidget {
  final String initialUrl;
  final int direction;

  const H5Webview({Key? key, required this.initialUrl, required this.direction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return H5WebviewShared(initialUrl: initialUrl, direction: direction);
  }
}
