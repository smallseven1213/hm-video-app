import 'package:flutter/material.dart';

class PageLoader extends StatelessWidget {
  final Widget loadingWidget;
  final Future Function() loadLibrary;
  final Widget Function() createPage;

  const PageLoader({
    Key? key,
    required this.loadingWidget,
    required this.loadLibrary,
    required this.createPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadLibrary(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return createPage();
        } else {
          return loadingWidget; // Or any loading indicator you like
        }
      },
    );
  }
}
