// ignore: avoid_web_libraries_in_flutter
import 'package:flutter/material.dart';
import 'package:fwfh_webview/fwfh_webview.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

class H5WebviewShared extends StatelessWidget {
  final String initialUrl;

  const H5WebviewShared({Key? key, required this.initialUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('initialUrl: $initialUrl');
    final orientation = MediaQuery.of(context).orientation;
    return RotatedBox(
      quarterTurns: orientation == Orientation.portrait ? 1 : 0,
      child: Container(
        decoration: const BoxDecoration(color: Colors.black),
        child: Center(
          child: HtmlWidget(
            '<iframe src="$initialUrl"></iframe>',
            factoryBuilder: () => MyWidgetFactory(),
          ),
        ),
      ),
    );
  }
}

class MyWidgetFactory extends WidgetFactory with WebViewFactory {
  // optional: override getter to configure how WebViews are built
  @override
  bool get webViewMediaPlaybackAlwaysAllow => true;
  @override
  String? get webViewUserAgent => 'My app';
}
