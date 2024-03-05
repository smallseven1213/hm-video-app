import 'package:shared/controllers/system_config_controller.dart';
import 'package:shared/utils/fetcher.dart';
import 'package:get/get.dart';

import '../models/third_login_api_response_with_data.dart';

class GameAuthApi {
  static final GameAuthApi _instance = GameAuthApi._internal();
  SystemConfigController systemController = Get.find<SystemConfigController>();

  GameAuthApi._internal();

  factory GameAuthApi() {
    return _instance;
  }

  Future<ThirdLoginApiResponseBaseWithData> login(String token) async {
    var response = await fetcher(
        url: '${systemController.apiHost.value}/api/v1/third/login',
        method: 'POST',
        body: {
          'apiId': 1, // gp=1, 直播=2
        });

    return ThirdLoginApiResponseBaseWithData.fromJson(response.data);
  }
}
