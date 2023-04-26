import 'package:flutter/material.dart';

class GameLobby extends StatefulWidget {
  const GameLobby({super.key});

  @override
  State<GameLobby> createState() => _GameLobbyState();
}

class _GameLobbyState extends State<GameLobby> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('游戏大厅'),
      ),
      body: const Center(
        child: Text(
          '游戏大厅',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.white, // TODO: use dark/light
          ),
        ),
      ),
    );
  }
}
