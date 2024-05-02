import 'package:flutter/material.dart';

import '../../models/game.dart';
import 'cross_column_game_card.dart';
import 'horizontal_game_card.dart';
import 'vertical_game_card.dart';

class GameArea extends StatelessWidget {
  final Game game;

  const GameArea({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    dynamic widget = CrossColumnGameCard(gameBlocks: game);
    if (game.template == 1) {
      widget = VerticalGameCard(gameBlocks: game);
    } else if (game.template == 2) {
      widget = HorizontalGameCard(gameBlocks: game);
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: widget,
    );
  }
}
