import 'package:flutter/material.dart';
import '../apis/game_api.dart';
import '../models/infinity_games.dart';
import 'base_games_infinity_scroll_controller.dart';

final gameApi = GameApi();
const limit = 20;

class GamesController extends BaseGamesInfinityScrollController {
  final int gameAreaId;

  GamesController(
      {required this.gameAreaId,
      ScrollController? scrollController,
      bool loadDataOnInit = true})
      : super(
            loadDataOnInit: loadDataOnInit,
            customScrollController: scrollController);

  @override
  Future<InfinityGames> fetchData(int page) async {
    var res = await gameApi.getGames(gameAreaId, page: page, limit: limit);

    return res;
  }
}
