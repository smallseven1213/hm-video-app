import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class AuthController extends GetxController {
  var token = ''.obs;

  @override
  void onReady() {
    super.onReady();
    final box = GetStorage();
    String? storedToken = box.read('auth-token');
    logger.i('TRACE TOKEN ===, storedToken: $storedToken');
    if (storedToken != null) {
      token.value = storedToken;
    }
  }

  void setToken(String? newToken) {
    logger.i('TRACE TOKEN ===, token: $newToken');
    token.value = newToken ?? '';
    final box = GetStorage();
    box.write('auth-token', newToken);
  }
}
