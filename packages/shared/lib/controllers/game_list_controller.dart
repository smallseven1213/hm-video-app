import 'package:get/get.dart';
import 'package:shared/apis/game_api.dart';
import 'package:shared/controllers/auth_controller.dart';

import '../models/game_list.dart';

class GamesListController extends GetxController {
  var games = <GameItem>[].obs;
  var isShowFab = false.obs;
  var switchPaymentPage = 0.obs;
  final RxInt selectedCategoryIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _fetchGames();
    Get.find<AuthController>().token.listen((event) {
      _fetchGames();
    });
  }

  Future<void> _fetchGames() async {
    print('loading game states');
    var res = await GameLobbyApi().getGames(); // [{}]
    games.assignAll(res);
  }

  // _getGameLobbyShowConfig() async {
  //   var resGameConfig = await Get.put(GameLobbyApi()).getGameConfig();
  //   isShowFab = resGameConfig.distributed.obs;
  //   switchPaymentPage.value = resGameConfig.paymentPage;
  // }

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
