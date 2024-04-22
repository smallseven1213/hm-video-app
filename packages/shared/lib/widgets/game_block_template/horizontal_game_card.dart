import 'dart:math';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../models/game.dart';
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
    print('@@@@ HorizontalGameCard');
    print(gameBlocks);

    return AspectRatio(
      aspectRatio: 360 / 444,
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
        Container(
          width: double.infinity,
          color: kCardBgColor,
          // margin: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                game.name,
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
    );
  }

  Widget _buildGameImage() {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 168 / 120,
          child: Container(
            // margin: const EdgeInsets.only(left: 8, right: 8, top: 8),
            child: Image.network(
              'https://5b0988e595225.cdn.sohucs.com/images/20170820/726480d5869049e29698e0d472715406.jpeg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
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
        children: game.tags!
            .map((tag) => TagWidget(
                  tag: tag,
                ))
            .toList(),
      ),
    );
  }
}
