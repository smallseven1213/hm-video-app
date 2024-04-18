import 'package:get/get.dart';
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
      var res =
          await fetcher(url: '$apiHost/gameArea?page=1&limit=20&sortBy=random');
      if (res.data['code'] != '00') {
        return [];
      }
      return List.from(
          (res.data['data'] as List<dynamic>).map((e) => Game.fromJson(e)));
    } catch (e) {
      return [];
    }
  }
}
