import 'package:shared/models/game.dart';

class InfinityGames {
  final List<GameDetail> games;
  final int totalCount;
  final bool hasMoreData;

  InfinityGames(this.games, this.totalCount, this.hasMoreData);
}
