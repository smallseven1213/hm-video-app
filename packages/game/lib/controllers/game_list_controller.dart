import 'package:game/apis/game_api.dart';
import 'package:game/models/game_platform.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../models/game_list.dart';

final logger = Logger();

class GamesListController extends GetxController {
  RxList games = <GameItem>[].obs;
  var isShowFab = false.obs;
  final RxInt selectedCategoryIndex = 0.obs;
  var isMaintenance = false.obs;
  var gamePlatformList = <GamePlatformItem>[].obs;
  RxInt gameTypeIndex = 0.obs; // 左側遊戲類型index
  var gamePlatformTpCode = Rxn<String>(); // 右側上方遊戲平台tpCode，可以為null或空字串
  var resetVerticalFilter = false.obs;

  Future<void> fetchGames() async {
    try {
      var res = await GameLobbyApi().getGames(); // [{}]
      games.assignAll(res);
    } catch (e) {
      logger.e('fetchGames error: $e');
    }
  }

  Future<void> fetchGamePlatform() async {
    try {
      var res = await GameLobbyApi().getGamePlatform();
      gamePlatformList.value = res;
    } catch (error) {
      logger.i('fetchGetGamePlatform error: $error');
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

  void setGameTypeIndex(int index) {
    gameTypeIndex.value = index;
    update(['gameList']);
  }

  void setGamePlatformTpCode(String? tpCode) {
    gamePlatformTpCode.value = tpCode;
  }

  void triggerVerticalFilterReset() {
    resetVerticalFilter.value = !resetVerticalFilter.value;
    update(['gameList']);
  }
}
