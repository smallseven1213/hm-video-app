import 'package:get/get.dart';
import 'package:shared/models/infinity_games.dart';
import '../controllers/system_config_controller.dart';
import '../models/game.dart';
import '../utils/fetcher.dart';

class GameApi {
  static final GameApi _instance = GameApi._internal();

  GameApi._internal();

  factory GameApi() {
    return _instance;
  }

  final SystemConfigController _systemConfigController =
      Get.find<SystemConfigController>();

  String get apiHost => _systemConfigController.apiHost.value!;

  Future<List<Game>> getGameArea() async {
    try {
      var res = await fetcher(
          url: '$apiHost/api/v1/gameArea?page=1&limit=20&sortBy=random');
      if (res.data['code'] != '00') {
        return [];
      }
      return List.from((res.data['data']['data'] as List<dynamic>).map((e) {
        print(e);
        return Game.fromJson(e);
      }));
    } catch (e) {
      return [];
    }
  }

  Future<InfinityGames> getGames(int gameAreaId,
      {int page = 1, int limit = 20}) async {
    try {
      var res = await fetcher(
          url:
              '$apiHost/api/v1/game?page=$page&limit=$limit&gameAreaId=$gameAreaId');
      if (res.data['code'] != '00') {
        return InfinityGames(
          [],
          0,
          false,
        );
      }
      List<GameDetail> games =
          List.from((res.data['data']['data'] as List<dynamic>).map((e) {
        return GameDetail.fromJson(e);
      }));
      int total = res.data['data']['total'];
      int retrievedLimit =
          res.data['data']['limit']; // Rename the inner 'limit' variable
      bool hasMoreData =
          total > retrievedLimit * page; // Use the renamed variable here
      return InfinityGames(games, total, hasMoreData);
    } catch (e) {
      return InfinityGames(
        [],
        0,
        false,
      );
    }
  }
}
