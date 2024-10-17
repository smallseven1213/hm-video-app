// ignore: avoid_web_libraries_in_flutter
import 'dart:html' if (dart.library.html) 'dart:html' as html;
import 'dart:ui_web' as ui;

import 'package:flutter/material.dart';
import 'package:game/utils/loading.dart';

class H5WebviewShared extends StatefulWidget {
  final String initialUrl;
  final int direction;
  final bool openInNewWindow;

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
  final String viewType = 'game-html-${DateTime.now().microsecondsSinceEpoch}';
  html.IFrameElement? iframeElement;
  bool toggleButton = false;

  @override
  void initState() {
    super.initState();
    registerViewFactory();
  }

  @override
  void dispose() {
    unregisterViewFactory();
    super.dispose();
  }

  void registerViewFactory() {
    iframeElement = html.IFrameElement()
      ..src = widget.initialUrl
      ..style.border = 'none'
      ..width = '100%'
      ..height = '100%'
      ..allowFullscreen = true;

    // 在iframe中加入fullScreenApi.js的script標籤
    html.ScriptElement scriptElement = html.ScriptElement()
      ..type = 'text/javascript'
      ..src =
          'https://client.pragmaticplaylive.net/desktop/assets/api/fullscreenApi.js'; // 將路徑替換為實際的fullScreenApi.js路徑

    html.document.head?.append(scriptElement);

    // 在 iframe 加載完成後動態添加 cache-control 標頭
    iframeElement!.onLoad.listen((_) {
      var meta = html.MetaElement(); // 創建 MetaElement
      meta.httpEquiv = 'Cache-Control'; // 設置 httpEquiv
      meta.content = 'no-cache, no-store, must-revalidate'; // 設置 content
      html.document.head?.append(meta);
    });

// ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      viewType,
      (int viewId) {
        html.document.getElementById(viewType)?.append(iframeElement!);
        return iframeElement!;
      },
    );
  }

  void unregisterViewFactory() {
    html.document.getElementById(viewType)?.remove();
  }

  void toggleButtonRow() {
    setState(() {
      toggleButton = !toggleButton;
    });
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;

    return Stack(
      children: [
        // 加入loading
        const Center(child: GameLoading()),
        HtmlElementView(viewType: viewType),
        // if (toggleButton)
        //   Center(
        //     child: PointerInterceptor(
        //       child: GameWebviewToggleButtonWidget(
        //         toggleButtonRow: toggleButtonRow,
        //         direction: widget.direction,
        //       ),
        //     ),
        //   ),
        // Positioned(
        //   top: MediaQuery.of(context).size.height - 70,
        //   left: widget.direction == gameWebviewDirection['vertical']
        //       ? MediaQuery.of(context).size.width - 70
        //       : (orientation == Orientation.portrait
        //           ? 20
        //           : MediaQuery.of(context).size.width - 70),
        //   child: RotatedBox(
        //     quarterTurns: widget.direction == gameWebviewDirection['vertical']
        //         ? (orientation == Orientation.portrait ? 0 : 1)
        //         : (orientation == Orientation.portrait ? 1 : 0),
        //     child: PointerInterceptor(
        //       child: InkWell(
        //         onTap: () {
        //           setState(() {
        //             toggleButton = !toggleButton;
        //           });
        //         },
        //         child: SizedBox(
        //           width: 55,
        //           height: 55,
        //           child: Image.asset(
        //             'packages/game/assets/images/game_lobby/icons-menu.webp',
        //             width: 40,
        //             height: 40,
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
