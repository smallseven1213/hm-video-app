import 'package:get/get.dart';
import 'package:game/apis/game_api.dart';
import 'package:game/controllers/game_auth_controller.dart';

import '../models/game_list.dart';

class GamesListController extends GetxController {
  var games = <GameItem>[].obs;
  var isShowFab = false.obs;
  final RxInt selectedCategoryIndex = 0.obs;
  var isMaintenance = false.obs;

  Future<void> fetchGames() async {
    logger.i('loading game states');
    var res = await GameLobbyApi().getGames(); // [{}]
    games.assignAll(res);
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
