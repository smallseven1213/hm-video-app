import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/game_area_controller.dart';
import 'package:shared/widgets/game_block_template/game_area.dart';

class RandomGameArea extends StatefulWidget {
  const RandomGameArea({super.key});

  @override
  RandomGameAreaState createState() => RandomGameAreaState();
}

class RandomGameAreaState extends State<RandomGameArea> {
  final gameAreaController = Get.find<GameAreaController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var gameAreas = gameAreaController.games;

      if (gameAreas.isNotEmpty) {
        var gameArea = gameAreaController.randomGame;
        dynamic templateWidget = GameArea(game: gameArea!);
        if (gameArea.template == 2) {
          templateWidget = GameArea(game: gameArea);
        } else if (gameArea.template == 3) {
          templateWidget = GameArea(game: gameArea);
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: templateWidget,
        );
      }
      return Container();
    });
  }
}
