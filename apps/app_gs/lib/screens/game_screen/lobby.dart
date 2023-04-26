import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/screens/game/lobby.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const GameLobby();
  }
}
