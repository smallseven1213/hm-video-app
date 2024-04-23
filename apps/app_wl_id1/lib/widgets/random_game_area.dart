import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/game_area_controller.dart';

import 'game_area_templates/game_area_template_1.dart';
import 'game_area_templates/game_area_template_2.dart';
import 'game_area_templates/game_area_template_3.dart';

class RandomGameArea extends StatefulWidget {
  const RandomGameArea({super.key});

  @override
  RandomGameAreaState createState() => RandomGameAreaState();
}

class RandomGameAreaState extends State<RandomGameArea> {
  final gameAreaController = Get.find<GameAreaController>();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Obx(() {
        var gameAreas = gameAreaController.games;

        if (gameAreas.isNotEmpty) {
          var gameArea = gameAreaController.randomGame;
          dynamic templateWidget = GameAreaTemplate1(gameArea: gameArea!);
          if (gameArea.template == 2) {
            templateWidget = GameAreaTemplate2(gameArea: gameArea);
          } else if (gameArea.template == 3) {
            templateWidget = GameAreaTemplate3(gameArea: gameArea);
          }

          return Padding(
            // padding x 10
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(gameArea.name,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    // see all
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      height: 24,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color(0xFF00669F), width: 1),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4)),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          // navigate to game area
                          // Get.toNamed('/game_area/${gameArea.id}');
                        },
                        child: const Align(
                          alignment: Alignment.center,
                          child: Text(
                            'See All',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                templateWidget
              ],
            ),
          );
        }
        return Container();
      }),
    );
  }
}
