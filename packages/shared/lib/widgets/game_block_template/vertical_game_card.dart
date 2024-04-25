import 'package:flutter/material.dart';
import '../../models/game.dart';
import 'game_template_link.dart';
import 'header.dart';
import 'tag.dart';

const kPrimaryColor = Color(0xff00669F);
const kCardBgColor = Color(0xff02275C);
const kSpacingUnit = 8.0;

class VerticalGameCard extends StatelessWidget {
  final Game gameBlocks;

  const VerticalGameCard({
    super.key,
    required this.gameBlocks,
  });

  @override
  Widget build(BuildContext context) {
    var games = gameBlocks.games.take(4).toList();

    return AspectRatio(
      aspectRatio: 360 / 560,
      child: Column(
        children: [
          HeaderWidget(gameBlocks: gameBlocks),
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
          _buildGameTags(),
        ],
      ),
    );
  }

  Widget _buildGameImage() {
    return AspectRatio(
      aspectRatio: 168 / 200,
      child: Stack(
        children: [
          Image.network(
            gameDetail.verticalLogo ?? '',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          _buildGradientTextOverlay(),
        ],
      ),
    );
  }

  Widget _buildGradientTextOverlay() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black.withOpacity(0.8), Colors.transparent],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            gameDetail.name,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGameTags() {
    return Container(
      width: double.infinity,
      height: 36,
      color: kCardBgColor,
      padding: const EdgeInsets.all(8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal, // 水平滚动
        child: Wrap(
          spacing: 5.0,
          runSpacing: 5.0,
          children:
              gameDetail.tags?.map((tag) => TagWidget(tag: tag)).toList() ?? [],
        ),
      ),
    );
  }
}
