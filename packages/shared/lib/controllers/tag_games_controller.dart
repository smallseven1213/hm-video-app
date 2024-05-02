import 'package:flutter/material.dart';
import 'package:shared/models/infinity_games.dart';
import '../apis/game_api.dart';
import 'base_games_infinity_scroll_controller.dart';

final gameApi = GameApi();
const limit = 20;

class TagGamesController extends BaseGamesInfinityScrollController {
  final String tag;

  TagGamesController(
      {required this.tag,
      ScrollController? scrollController,
      bool loadDataOnInit = true})
      : super(
            loadDataOnInit: loadDataOnInit,
            customScrollController: scrollController);

  @override
  Future<InfinityGames> fetchData(int page) async {
    var res = await gameApi.getGames(page: page, tag: tag, limit: limit);

    return res;
  }
}
