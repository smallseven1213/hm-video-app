import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../apis/user_api.dart';
import '../models/index.dart';
import 'auth_controller.dart';

final logger = Logger();

class UserPromoController extends GetxController {
  var promoteData = UserPromote('', '', -1, -1).obs;

// find AuthController
  final authController = Get.find<AuthController>();

  @override
  void onReady() {
    super.onReady();

    logger.i('TRACE TOKEN =====, INITIAL');
    if (authController.token.value.isNotEmpty) {
      getUserPromoteData();
    }

    ever(
      authController.token,
      (token) {
        logger.i('TRACE TOKEN =====, user controller token: $token');
        if (authController.token.value.isNotEmpty) {
          getUserPromoteData();
        }
      },
    );
  }

  Future<void> getUserPromoteData() async {
    try {
      var userApi = UserApi();
      UserPromote res = await userApi.getUserPromote();
      promoteData.value = res;
    } catch (error) {
      logger.i(error);
    }
  }
}
