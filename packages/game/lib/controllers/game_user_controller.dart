import 'package:game/models/user.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';

import 'package:game/apis/user_api.dart';
import 'package:game/controllers/game_auth_controller.dart';

final logger = Logger();

class GameUserController extends GetxController {
  var info = User(
    '',
    0,
    [],
  ).obs;
  var isLoading = false.obs;
  var totalAmount = 0.0.obs;
  var loginCode = ''.obs;

  bool get isGuest => info.value.roles.contains('guest');
  GetStorage box = GetStorage();

  // find AuthController
  final authController = Get.find<GameAuthController>();

  @override
  void onReady() {
    super.onReady();

    logger.i('TRACE TOKEN =====, INITIAL');
    if (authController.token.value.isNotEmpty) {
      fetchUserInfo();
    }

    ever(
      authController.token,
      (token) {
        logger.i('TRACE TOKEN =====, user controller token: $token');
        if (authController.token.value.isNotEmpty) {
          fetchUserInfo();
        }
      },
    );
  }

  fetchUserInfo() async {
    isLoading.value = true;
    try {
      var userApi = UserApi();
      var res = await userApi.getCurrentUser();
      info.value = res;
    } catch (error) {
      logger.i('fetchUserInfo error: $error');
    } finally {
      isLoading.value = false;
    }
  }

  void mutateInfo(User? user, bool revalidateFromServer) {
    if (user != null) {
      info.value = user;
    }
    if (revalidateFromServer) {
      fetchUserInfo();
    }
  }
}
