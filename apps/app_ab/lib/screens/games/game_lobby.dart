import 'package:flutter/material.dart';
import 'package:game/screens/lobby.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // HC: 煩死，勿動!!
      child: const GameLobby(),
    );
  }
}
