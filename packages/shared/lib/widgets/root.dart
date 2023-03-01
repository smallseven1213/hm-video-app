import 'package:flutter/material.dart';

import 'ad.dart';
import 'splash.dart';

enum Process { splash, ad, start }

class RootWidget extends StatefulWidget {
  final Widget widget;

  const RootWidget({Key? key, required this.widget}) : super(key: key);

  @override
  _RootWidgetState createState() => _RootWidgetState();
}

class _RootWidgetState extends State<RootWidget> {
  Process process = Process.splash;

  void toNextProcess({Process? nextProcess}) {
    if (nextProcess != null) {
      setState(() {
        process = nextProcess;
      });
    } else {
      if (process == Process.splash) {
        setState(() {
          process = Process.ad;
        });
      } else if (process == Process.ad) {
        setState(() {
          process = Process.start;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: process == Process.splash
          ? Splash(
              onNext: toNextProcess,
            )
          : process == Process.ad
              ? Ad(
                  onNext: toNextProcess,
                )
              : widget.widget,
    ));
  }
}
