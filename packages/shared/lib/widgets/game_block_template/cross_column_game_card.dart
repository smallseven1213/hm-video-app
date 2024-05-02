import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared/widgets/game_block_template/header.dart';

import '../../models/game.dart';
import 'game_template_link.dart';
import 'tag.dart';

const kTagColor = Color(0xff21488E);
const kTagTextColor = Color(0xffFFD527);
const kCardBgColor = Color(0xff02275C);

final logger = Logger();

class CrossColumnGameCard extends StatelessWidget {
  final Game gameBlocks;
  const CrossColumnGameCard({
    super.key,
    required this.gameBlocks,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> gameCards = [];
    for (var i = 0; i < gameBlocks.games.length && i < 3; i++) {
      gameCards.add(GameCard(game: gameBlocks.games[i]));
    }
    return Column(
      children: [
        HeaderWidget(gameBlocks: gameBlocks),
        ...gameCards,
      ],
    );
  }
}

class GameCard extends StatelessWidget {
  final GameDetail game;
  const GameCard({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return GameTemplateLink(
      url: game.gameUrl,
      child: Container(
        height: 96,
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: kCardBgColor,
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildLeftSide(),
            const SizedBox(width: 10),
            Expanded(
              child: _buildRightSide(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftSide() {
    return Image.network(
      game.horizontalLogo ?? '',
      fit: BoxFit.cover,
      errorBuilder:
          (BuildContext context, Object exception, StackTrace? stackTrace) {
        return Center(
          child: Icon(
            Icons.image_not_supported,
            color: Colors.grey.shade700,
            size: 30,
          ),
        );
      },
    );
  }

  Widget _buildRightSide() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              const Text('MULTIPLIER',
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFD4D4D4))),
              // width 5
              const SizedBox(width: 5),
              Text('${game.multiple.toString()}x',
                  style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFD527))),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            game.name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 16,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal, // 水平滚动
              child: Wrap(
                spacing: 4.0,
                runSpacing: 4.0,
                children: [
                  ...game.tags!
                      .map((tag) => TagWidget(
                            tag: tag,
                          ))
                      .toList(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                        color: kTagColor,
                        borderRadius: kIsWeb
                            ? BorderRadius.zero
                            : BorderRadius.circular(10)),
                    child: Text(
                      '${game.jackpot} USD',
                      style: const TextStyle(
                        color: kTagTextColor,
                        fontSize: 10,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
