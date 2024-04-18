import 'dart:math';

import 'package:flutter/material.dart';
import '../../models/game.dart';
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
    debugPrint('VerticalGameCard build called for: ${gameBlocks.name}');

    return AspectRatio(
      aspectRatio: 360 / 560,
      child: Column(
        children: [
          HeaderWidget(name: gameBlocks.name),
          _buildGameGrid(),
        ],
      ),
    );
  }

  Widget _buildGameGrid() {
    if (gameBlocks.games.isEmpty) {
      return const SizedBox.shrink();
    }

    List<Widget> rows = List<Widget>.generate(
      min(gameBlocks.games.length, 4) ~/ 2,
      (index) => _buildGameRow(index * 2),
    );

    // Insert spacing between rows
    for (int i = 1; i < rows.length; i += 2) {
      rows.insert(i, const SizedBox(height: kSpacingUnit));
    }

    return Expanded(child: Column(children: rows));
  }

  Widget _buildGameRow(int startIndex) {
    List<Widget> rowChildren = List<Widget>.generate(
      min(2, gameBlocks.games.length - startIndex),
      (index) {
        return Expanded(
          child: GameCard(game: gameBlocks.games[startIndex + index]),
        );
      },
    );

    // Add spacing between game cards in a row
    if (rowChildren.length > 1) {
      rowChildren.insert(1, const SizedBox(width: kSpacingUnit));
    }

    return Row(children: rowChildren);
  }
}

class GameCard extends StatelessWidget {
  final GameDetail game;

  const GameCard({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildGameImage(),
        _buildGameTags(),
      ],
    );
  }

  Widget _buildGameImage() {
    return AspectRatio(
      aspectRatio: 168 / 200,
      child: Stack(
        children: [
          Image.network(
            // game.verticalLogo,
            'https://5b0988e595225.cdn.sohucs.com/images/20170820/726480d5869049e29698e0d472715406.jpeg',
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
            game.name,
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
      child: Wrap(
        spacing: 5.0,
        runSpacing: 5.0,
        children: game.tags?.map((tag) => TagWidget(name: tag)).toList() ?? [],
      ),
    );
  }
}
