import 'package:get/get.dart';
import 'package:game/apis/game_api.dart';
import 'package:game/controllers/game_auth_controller.dart';

import '../models/game_list.dart';

class GamesListController extends GetxController {
  var games = <GameItem>[].obs;
  var isShowFab = false.obs;
  var switchPaymentPage = 0.obs;
  final RxInt selectedCategoryIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // fetchGames();
    Get.find<GameAuthController>().token.listen((event) {
      fetchGames();
    });
  }

  Future<void> fetchGames() async {
    print('loading game states');
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
}
