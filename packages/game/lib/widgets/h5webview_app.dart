import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

final logger = Logger();

class H5WebviewShared extends StatefulWidget {
  final String initialUrl;
  final int direction;
  final bool? openInNewWindow;

  const H5WebviewShared({
    Key? key,
    required this.initialUrl,
    required this.direction,
    this.openInNewWindow = false,
  }) : super(key: key);

  @override
  H5WebviewSharedState createState() => H5WebviewSharedState();
}

class H5WebviewSharedState extends State<H5WebviewShared> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            if (request.url == widget.initialUrl) {
              return NavigationDecision.navigate;
            } else {
              if (widget.openInNewWindow == true) {
                Uri url = Uri.parse(request.url);
                launchUrl(url);
                return NavigationDecision.prevent;
              } else {
                return NavigationDecision.navigate;
              }
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.initialUrl));
  }

  @override
  Widget build(BuildContext context) {
    logger.i('initialUrl in H5WebviewShared: ${widget.initialUrl}');
    return PopScope(
      canPop: false,
      child: WebViewWidget(controller: _controller),
    );
  }

  @override
  void dispose() {
    _controller.loadRequest(Uri.parse('about:blank'));
    super.dispose();
  }
}
