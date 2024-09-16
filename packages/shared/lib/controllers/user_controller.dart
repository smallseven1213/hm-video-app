import 'package:game/services/game_system_config.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:logger/logger.dart';

import '../apis/user_api.dart';
import '../apis/auth_api.dart';
import '../models/index.dart';
import '../models/user_v2.dart';
import 'auth_controller.dart';

final logger = Logger();

class UserController extends GetxController {
  var info = User(
    '',
    0,
    [],
  ).obs;
  var infoV2 = UserV2(
    uid: 0,
    roles: [],
    nickname: '',
    points: 0,
    isFree: false,
  ).obs;
  var wallets = <WalletItem>[].obs;
  var isLoading = false.obs;
  var isInfoV2Init = false.obs;
  var isInfoV2Loading = false.obs;
  var totalAmount = 0.0.obs;
  var loginCode = ''.obs;
  IO.Socket? socket;
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
      fetchUserInfoV2();
      connectWebSocket(authController.token.value);
    }

    ever(
      authController.token,
      (token) {
        logger.i('TRACE TOKEN =====, user controller token: $token');
        if (authController.token.value.isNotEmpty) {
          fetchUserInfo();
          fetchUserInfoV2();
        }
      },
    );
  }

  void connectWebSocket(String token) {
    final systemConfig = GameSystemConfig();
    var websocketUrl = systemConfig.apiHost?.replaceAll("https://api.", "");
    final url = 'wss://ws.$websocketUrl:443/user?token=$token';

    socket = IO.io(url, <String, dynamic>{
      'transports': ['websocket'],
    });

    socket?.on('connect', (_) {
      logger.i('WebSocket connected');
    });

    socket?.on('event', (data) {
      logger.i('WebSocket event received: $data');
      handleEvent(data);
    });

    socket?.on('disconnect', (_) {
      logger.i('WebSocket disconnected');
    });
  }

  void handleEvent(dynamic data) {
    if (data['event'] == 'wallet.reduce') {
      var point = double.parse(data['data']['video.wallet'].toString());
      // 修改至V2的points
      infoV2.update((user) {
        user?.points = point;
        logger.i('video new wallet point $point');
      });
    }
    if (data['event'] == 'update.wallet') {
      var point = double.parse(data['data']['wallet'].toString());
      // 修改至V2的points
      infoV2.update((user) {
        user?.points = point;
        logger.i('game new wallet point $point ');
      });
    }
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

  fetchUserInfoV2() async {
    isInfoV2Loading.value = true;

    try {
      var userApi = UserApi();
      var res = await userApi.getCurrentUserV2();
      if (isInfoV2Init.value == false) {
        isInfoV2Init.value = true;
      }
      infoV2.value = res;
    } catch (error) {
      logger.i('fetchUserInfo error: $error');
    } finally {
      isInfoV2Loading.value = false;
    }
  }

  setAvatar(String photoSid) {
    info.update((val) {
      val!.avatar = photoSid;
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
