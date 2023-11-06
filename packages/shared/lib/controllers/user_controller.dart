import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';

import '../apis/user_api.dart';
import '../apis/auth_api.dart';
import '../models/index.dart';
import 'auth_controller.dart';

final logger = Logger();

class UserController extends GetxController {
  var info = User(
    '',
    0,
    [],
  ).obs;
  var wallets = <WalletItem>[].obs;
  var isLoading = false.obs;
  var totalAmount = 0.0.obs;
  var loginCode = ''.obs;

  bool get isGuest => info.value.roles.contains('guest');
  GetStorage box = GetStorage();

  // find AuthController
  final authController = Get.find<AuthController>();

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

  setAvatar(String photoSid) {
    info.update((val) {
      val!.avatar.val(photoSid);
    });
  }

  Future<void> getLoginCode() async {
    isLoading.value = true;
    try {
      var authApi = AuthApi();
      var res = await authApi.getLoginCode();
      loginCode.value = res.data['code'];
    } catch (error) {
      logger.i(error);
    } finally {
      isLoading.value = false;
    }
  }

  updateNickname(String nickname) {
    info.update((val) {
      val!.nickname = nickname;
    });
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
