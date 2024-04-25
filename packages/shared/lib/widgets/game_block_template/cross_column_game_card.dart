import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared/widgets/game_block_template/header.dart';

import '../../models/game.dart';
import 'game_template_link.dart';
import 'tag.dart';

const kCardBgColor = Color(0xff02275C);
const kTagColor = Color(0xff21488E);
const kTagTextColor = Color(0xff21AFFF);

final logger = Logger();

class CrossColumnGameCard extends StatelessWidget {
  final Game gameBlocks;
  const CrossColumnGameCard({
    super.key,
    required this.gameBlocks,
  });

  @override
  Widget build(BuildContext context) {
    print(gameBlocks);
    return AspectRatio(
      aspectRatio: 360 / 332,
      child: Column(
        children: [
          HeaderWidget(gameBlocks: gameBlocks),
          _buildGameGrid(context),
        ],
      ),
    );
  }

  Widget _buildGameGrid(BuildContext context) {
    if (gameBlocks.games.isEmpty) {
      return const SizedBox.shrink(); // 當games沒有資料時，返回一個空的widget
    }
    List<Widget> gameCards = [];
    for (var i = 0; i < gameBlocks.games.length && i < 3; i++) {
      gameCards.add(GameCard(game: gameBlocks.games[i]));
    }
    return Expanded(
      child: Column(
        children: gameCards,
      ),
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
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildLeftSide(),
              Expanded(
                child: _buildRightSide(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeftSide() {
    return AspectRatio(
      aspectRatio: 134 / 96,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(game.horizontalLogo),
            fit: BoxFit.cover,
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8.0),
            bottomLeft: Radius.circular(8.0),
          ),
        ),
        alignment: Alignment.bottomLeft,
      ),
    );
  }

  Widget _buildRightSide() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'MULTIPLIER ${game.multiple}x',
            style: const TextStyle(
              color: Color(0xffD4D4D4),
              fontWeight: FontWeight.w500,
              fontSize: 10,
            ),
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
            child: Wrap(
              spacing: 4.0,
              runSpacing: 4.0,
              children: game.tags!
                  .map((tag) => TagWidget(
                        tag: tag,
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
