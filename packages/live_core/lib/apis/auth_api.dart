import 'package:shared/controllers/system_config_controller.dart';
import 'package:shared/utils/fetcher.dart';
import 'package:get/get.dart';

class AuthApi {
  static final AuthApi _instance = AuthApi._internal();
  SystemConfigController systemController = Get.find<SystemConfigController>();

  AuthApi._internal();

  factory AuthApi() {
    return _instance;
  }

  Future<void> login(String token) => fetcher(
          url: '${systemController.apiHost.value}/api/v1/third/login',
          // url: 'https://auth-api.hmtech-dev.com/api/v1/third/login',
          method: 'POST',
          body: {
            'apiId': 2,
          });
}
