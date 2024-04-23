import 'package:flutter/material.dart';
import 'package:shared/models/game.dart';
import 'package:shared/widgets/sid_image.dart';

import 'game_tag.dart';
import 'game_template_link.dart';

class GameAreaTemplate2 extends StatelessWidget {
  final Game gameArea;

  const GameAreaTemplate2({super.key, required this.gameArea});

  @override
  Widget build(BuildContext context) {
    // Ensure that there are up to four games, no more
    var games = gameArea.games.take(4).toList();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // First row with the first two games, checks if the games exist
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
                child: games.length > 0
                    ? GameAreaTemplate2Data(gameDetail: games[0])
                    : Container() // Empty container if no game available
                ),
            SizedBox(width: 10),
            Expanded(
                child: games.length > 1
                    ? GameAreaTemplate2Data(gameDetail: games[1])
                    : Container() // Empty container if no game available
                ),
          ],
        ),
        const SizedBox(height: 10),
        // Second row with the third and potentially fourth games, checks if the games exist
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
                child: games.length > 2
                    ? GameAreaTemplate2Data(gameDetail: games[2])
                    : Container() // Empty container if no game available
                ),
            const SizedBox(width: 10),
            Expanded(
                child: games.length > 3
                    ? GameAreaTemplate2Data(gameDetail: games[3])
                    : Container() // Empty container if no game available, ensures placeholder
                ),
          ],
        ),
      ],
    );
  }
}

class GameAreaTemplate2Data extends StatelessWidget {
  final GameDetail gameDetail;
  const GameAreaTemplate2Data({super.key, required this.gameDetail});

  @override
  Widget build(BuildContext context) {
    return GameTemplateLink(
      url: gameDetail.gameUrl,
      child: Container(
        height: 174,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            color: Color(0xFF02275C)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            SizedBox(
              height: 120,
              child: Image.network(gameDetail.horizontalLogo,
                  height: 120, fit: BoxFit.cover),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // title
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        gameDetail.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 5),
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
            ),
          ],
        ),
      ),
    );
  }
}
