// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

import 'package:game/models/game_list.dart';
import 'package:game/screens/game_webview_screen/game_webview_toggle_button.dart';

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
      ..height = '100%';

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
        HtmlElementView(
          viewType: viewType,
        ),
        if (toggleButton)
          Center(
            child: PointerInterceptor(
              child: GameWebviewToggleButtonWidget(
                toggleButtonRow: toggleButtonRow,
                direction: widget.direction,
              ),
            ),
          ),
        Positioned(
          top: Get.height - 70,
          left: widget.direction == gameWebviewDirection['vertical']
              ? Get.width - 70
              : (orientation == Orientation.portrait ? 20 : Get.width - 70),
          child: RotatedBox(
            quarterTurns: widget.direction == gameWebviewDirection['vertical']
                ? (orientation == Orientation.portrait ? 0 : 1)
                : (orientation == Orientation.portrait ? 1 : 0),
            child: PointerInterceptor(
              child: InkWell(
                onTap: () {
                  setState(() {
                    toggleButton = !toggleButton;
                  });
                },
                child: SizedBox(
                  width: 55,
                  height: 55,
                  child: Image.asset(
                    'packages/game/assets/images/game_lobby/icons-menu.webp',
                    width: 40,
                    height: 40,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
