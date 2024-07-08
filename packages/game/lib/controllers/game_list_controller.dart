import 'package:game/apis/game_api.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../models/game_list.dart';

final logger = Logger();

class GamesListController extends GetxController {
  var games = <GameItem>[].obs;
  var isShowFab = false.obs;
  final RxInt selectedCategoryIndex = 0.obs;
  var isMaintenance = false.obs;

  Future<void> fetchGames() async {
    try {
      var res = await GameLobbyApi().getGames(); // [{}]
      games.assignAll(res);
      logger.i('fetchGames: $res');
    } catch (e) {
      logger.e('fetchGames: $e');
    }
  }

  void updateGame(GameItem game) {
    final index = games.indexWhere((element) => element.gameId == game.gameId);
    if (index != -1) {
      games[index] = game;
    }
  }

  void updateSelectedCategoryIndex(int index) {
    selectedCategoryIndex.value = index;
  }

  void setMaintenanceStatus(bool status) {
    isMaintenance.value = status;
  }
}
