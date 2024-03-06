import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:webview_flutter/webview_flutter.dart';

final logger = Logger();

class H5WebviewShared extends StatefulWidget {
  final String initialUrl;
  final int direction;

  const H5WebviewShared(
      {Key? key, required this.initialUrl, required this.direction})
      : super(key: key);

  @override
  H5WebviewSharedState createState() => H5WebviewSharedState();
}

class H5WebviewSharedState extends State<H5WebviewShared> {
  final _controller = ValueNotifier<WebViewController?>(null);

  @override
  Widget build(BuildContext context) {
    logger.i('initialUrl in H5WebviewShared: ${widget.initialUrl}');
    return PopScope(
      canPop: false,
      child: WebView(
        initialUrl: widget.initialUrl,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.value = webViewController;
        },
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
