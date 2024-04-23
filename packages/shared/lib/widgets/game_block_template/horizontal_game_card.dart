import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../models/game.dart';
import 'game_template_link.dart';
import 'header.dart';
import 'tag.dart';

const kPrimaryColor = Color(0xff00669F);
const kCardBgColor = Color(0xff02275C);
const kTagColor = Color(0xff21488E);
const kTagTextColor = Color(0xff21AFFF);

final logger = Logger();

const kSpacingUnit = 8.0;

class HorizontalGameCard extends StatelessWidget {
  final Game gameBlocks;
  const HorizontalGameCard({
    super.key,
    required this.gameBlocks,
  });

  @override
  Widget build(BuildContext context) {
    var games = gameBlocks.games.take(4).toList();

    return AspectRatio(
      aspectRatio: 360 / 444,
      child: Column(
        children: [
          HeaderWidget(name: gameBlocks.name),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                  child: games.isNotEmpty
                      ? GameCard(gameDetail: games[0])
                      : Container() // Empty container if no game available
                  ),
              const SizedBox(width: 10),
              Expanded(
                  child: games.length > 1
                      ? GameCard(gameDetail: games[1])
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
                      ? GameCard(gameDetail: games[2])
                      : Container() // Empty container if no game available
                  ),
              const SizedBox(width: 10),
              Expanded(
                  child: games.length > 3
                      ? GameCard(gameDetail: games[3])
                      : Container() // Empty container if no game available, ensures placeholder
                  ),
            ],
          ),
        ],
      ),
    );
  }
}

class GameCard extends StatelessWidget {
  final GameDetail gameDetail;
  const GameCard({super.key, required this.gameDetail});

  @override
  Widget build(BuildContext context) {
    return GameTemplateLink(
      url: gameDetail.gameUrl,
      child: Column(
        children: [
          _buildGameImage(),
          Container(
            width: double.infinity,
            color: kCardBgColor,
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  gameDetail.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                _buildGameTags(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameImage() {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 168 / 120,
          child: Image.network(
            gameDetail.horizontalLogo,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        const Positioned(
          top: 0,
          left: 5,
          child: Image(
            image: AssetImage('assets/images/hot.png'),
            fit: BoxFit.contain,
            height: 24,
          ),
        )
      ],
    );
  }

  Widget _buildGameTags() {
    return Container(
      width: double.infinity,
      height: 16,
      color: kCardBgColor,
      padding: const EdgeInsets.all(8),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.start,
        spacing: 5.0,
        runSpacing: 5.0,
        clipBehavior: Clip.antiAlias,
        children: gameDetail.tags!
            .map((tag) => TagWidget(
                  tag: tag,
                ))
            .toList(),
      ),
    );
  }
}
