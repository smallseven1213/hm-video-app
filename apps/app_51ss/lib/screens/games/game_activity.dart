// paymentPage:2 列表
import 'package:flutter/material.dart';
import 'package:game/screens/game_activity_screen/index.dart';

class GameActivityScreen extends StatelessWidget {
  final int id;
  const GameActivityScreen({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GameActivity(id: id);
  }
}
