import 'package:flutter/material.dart';
import 'package:game/widgets/h5webview.dart';
import 'package:logger/logger.dart';
import 'package:webview_flutter/webview_flutter.dart';

final logger = Logger();

class WebViewPage extends StatefulWidget {
  final String url;
  final String title;

  const WebViewPage({
    Key? key,
    required this.url,
    required this.title,
  }) : super(key: key);

  @override
  WebViewPageState createState() => WebViewPageState();
}

class WebViewPageState extends State<WebViewPage> {
  final _controller = ValueNotifier<WebViewController?>(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: Container(),
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        ),
      ),
      body: H5Webview(
        initialUrl: widget.url,
        direction: 0,
      ),
    );
  }

  @override
  void dispose() {
    final currentWebview = _controller.value;
    if (currentWebview != null) {
      currentWebview.loadUrl('about:blank');
    }
    super.dispose();
  }
}
