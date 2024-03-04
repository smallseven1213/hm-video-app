import 'package:game/controllers/game_config_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class GameAuthController extends GetxController {
  var token = ''.obs;

  GetStorage box = GetStorage();

  @override
  void onReady() {
    super.onReady();
    String? storedToken = box.read('auth-token');
    logger.i('TRACE TOKEN ===, storedToken: $storedToken');
    if (storedToken != null) {
      token.value = storedToken;
    }

    Get.find<GameConfigController>();
  }

  void setToken(String? newToken) {
    logger.i('TRACE TOKEN ===, token: $newToken');
    token.value = newToken ?? '';
    box.write('auth-token', newToken);
  }
}
