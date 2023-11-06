import 'package:flutter/material.dart';
import 'package:game/widgets/game_startup.dart';
import 'package:get/get.dart';

class GameProvider extends StatelessWidget {
  final Widget child;

  const GameProvider({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(GameStartupController());
    return child;
  }
}
