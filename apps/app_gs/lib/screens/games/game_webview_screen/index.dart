import 'package:flutter/material.dart';
import 'package:game/screens/game_webview_screen/index.dart';

class GameWebviewScreen extends StatelessWidget {
  final String gameUrl;

  const GameWebviewScreen({Key? key, required this.gameUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GameLobbyWebview(gameUrl: gameUrl);
  }
}
