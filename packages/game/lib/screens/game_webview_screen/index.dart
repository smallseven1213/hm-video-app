import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game/screens/game_webview_screen/game_webview_toggle_button.dart';
import 'package:game/widgets/draggable_button.dart';
import 'package:logger/logger.dart';
import 'package:get/get.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

import 'package:game/widgets/h5webview.dart';

final logger = Logger();

class GameLobbyWebview extends StatefulWidget {
  final String gameUrl;
  final int direction;
  const GameLobbyWebview(
      {Key? key, required this.gameUrl, required this.direction})
      : super(key: key);

  @override
  State<GameLobbyWebview> createState() => _GameLobbyWebview();
}

class _GameLobbyWebview extends State<GameLobbyWebview> {
  bool toggleButton = false;
  final GlobalKey _parentKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (!GetPlatform.isWeb) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]);

      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (!GetPlatform.isWeb) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
          overlays: SystemUiOverlay.values);
    }
  }

  toggleButtonRow() {
    logger.i('toggleButtonRow');
    setState(() {
      toggleButton = !toggleButton;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: OrientationBuilder(builder: (context, orientation) {
      return LayoutBuilder(builder: (context, constraints) {
        return Stack(
          key: _parentKey,
          children: [
            H5Webview(
              initialUrl: widget.gameUrl,
              direction: widget.direction,
            ),
            if (!GetPlatform.isWeb)
              Center(
                child: toggleButton
                    ? PointerInterceptor(
                        child: GameWebviewToggleButtonWidget(
                        toggleButtonRow: () => toggleButtonRow(),
                        direction: widget.direction,
                      ))
                    : Container(),
              ),
            if (!GetPlatform.isWeb)
              DraggableFloatingActionButton(
                initialOffset: Offset(
                    constraints.maxWidth - 70, constraints.maxHeight - 70),
                child: PointerInterceptor(
                  child: InkWell(
                    onTap: () => toggleButtonRow(),
                    child: GestureDetector(
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
      });
    }));
  }
}
