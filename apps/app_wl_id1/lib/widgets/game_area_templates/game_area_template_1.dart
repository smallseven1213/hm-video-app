import 'package:flutter/material.dart';
import 'package:shared/models/game.dart';
import 'package:shared/widgets/sid_image.dart';

import 'game_tag.dart';
import 'game_template_link.dart';

class GameAreaTemplate1 extends StatelessWidget {
  final Game gameArea;

  const GameAreaTemplate1({super.key, required this.gameArea});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // repeat game.games
        for (var game in gameArea.games) ...[
          // game
          GameAreaTemplate1Data(gameDetail: game),
        ]
      ],
    );
  }
}

class GameAreaTemplate1Data extends StatelessWidget {
  final GameDetail gameDetail;
  const GameAreaTemplate1Data({super.key, required this.gameDetail});

  @override
  Widget build(BuildContext context) {
    return GameTemplateLink(
      url: gameDetail.gameUrl,
      child: Container(
        height: 96,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            color: Color(0xFF02275C)),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            // left image, right column
            SizedBox(
              width: 134,
              height: 96,
              // child is a network image from "gameDetail.horizontalLogo"
              child: Image.network(gameDetail.horizontalLogo),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                // align left
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const Text('MULTIPLIER',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFD4D4D4))),
                      // width 5
                      const SizedBox(width: 5),
                      Text(gameDetail.multiple.toString(),
                          style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFFD527))),
                    ],
                  ),
                  // title
                  Text(gameDetail.name,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  // tags
                  if (gameDetail.tags?.isNotEmpty == true)
                    Row(
                      children: [
                        for (var tag in gameDetail.tags!)
                          GameTag(text: tag.name),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
