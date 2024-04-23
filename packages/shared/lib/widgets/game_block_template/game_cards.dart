import 'package:flutter/material.dart';

import '../../models/game.dart';
import 'cross_column_game_card.dart';
import 'horizontal_game_card.dart';
import 'vertical_game_card.dart';

class GameCardWidget extends StatelessWidget {
  final Game game;

  const GameCardWidget({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    if (game.template == 1) {
      return VerticalGameCard(gameBlocks: game);
    } else if (game.template == 2) {
      return HorizontalGameCard(gameBlocks: game);
    }
    return CrossColumnGameCard(gameBlocks: game);
  }
}
