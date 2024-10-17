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
        navigationDelegate: (NavigationRequest request) {
          // 检查是否是初始 URL
          if (request.url == widget.initialUrl) {
            return NavigationDecision.navigate;
          } else {
            if (widget.openInNewWindow == true) {
              // 在新窗口打开链接
              Uri url = Uri.parse(request.url);
              launchUrl(url);
              return NavigationDecision.prevent;
            } else {
              // 在当前 WebView 中打开链接
              return NavigationDecision.navigate;
            }
          }
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
