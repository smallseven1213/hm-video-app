import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../apis/game_api.dart';
import '../models/game.dart';

final logger = Logger();

class GameAreaController extends GetxController {
  final games = <Game>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  fetchData() async {
    var res = await GameApi().getGameArea();
    games.assignAll(res);
  }
}
