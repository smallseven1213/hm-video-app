import 'package:shared/controllers/system_config_controller.dart';
import 'package:shared/utils/fetcher.dart';
import 'package:get/get.dart';

import '../models/live_api_response_with_data.dart';

class AuthApi {
  static final AuthApi _instance = AuthApi._internal();
  SystemConfigController systemController = Get.find<SystemConfigController>();

  AuthApi._internal();

  factory AuthApi() {
    return _instance;
  }

  Future<LiveApiResponseBaseWithDataWithData> login(String token) async {
    var response = await fetcher(
        url: '${systemController.apiHost.value}/api/v1/third/login',
        method: 'POST',
        body: {
          'apiId': 2,
        });

    return LiveApiResponseBaseWithDataWithData.fromJson(response.data);
  }
}
