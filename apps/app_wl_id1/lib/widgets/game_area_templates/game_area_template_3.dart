import 'package:flutter/material.dart';
import 'package:shared/models/game.dart';
import 'package:shared/widgets/sid_image.dart';

import 'game_tag.dart';
import 'game_template_link.dart';

class GameAreaTemplate3 extends StatelessWidget {
  final Game gameArea;

  const GameAreaTemplate3({super.key, required this.gameArea});

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
                    ? GameAreaTemplate3Data(gameDetail: games[0])
                    : Container() // Empty container if no game available
                ),
            SizedBox(width: 10),
            Expanded(
                child: games.length > 1
                    ? GameAreaTemplate3Data(gameDetail: games[1])
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
                    ? GameAreaTemplate3Data(gameDetail: games[2])
                    : Container() // Empty container if no game available
                ),
            const SizedBox(width: 10),
            Expanded(
                child: games.length > 3
                    ? GameAreaTemplate3Data(gameDetail: games[3])
                    : Container() // Empty container if no game available, ensures placeholder
                ),
          ],
        ),
      ],
    );
  }
}

class GameAreaTemplate3Data extends StatelessWidget {
  final GameDetail gameDetail;
  const GameAreaTemplate3Data({super.key, required this.gameDetail});

  @override
  Widget build(BuildContext context) {
    return GameTemplateLink(
      url: gameDetail.gameUrl,
      child: Container(
        height: 240,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            color: Color(0xFF02275C)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Container(
                height: 200,
                child: Stack(
                  children: [
                    Image.network(gameDetail.horizontalLogo,
                        height: 200, fit: BoxFit.cover),
                    //在此處bottom 0, 增加一個w100 h30的漸層container,opacity從上到下為0到8, 為黑色
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 40,
                        // color: Colors.black,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Color(0xFF000000).withOpacity(0.8),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 10,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(gameDetail.name,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                    ),
                  ],
                )),
            const SizedBox(width: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
