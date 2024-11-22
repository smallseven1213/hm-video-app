import 'package:get/get.dart';

import '../controllers/system_config_controller.dart';
import '../utils/fetcher.dart';

class JingangApi {
  static final JingangApi _instance = JingangApi._internal();

  JingangApi._internal();

  factory JingangApi() {
    return _instance;
  }

  final SystemConfigController _systemConfigController =
      Get.find<SystemConfigController>();

  String get apiHost => _systemConfigController.apiHost.value!;
  String get apiPrefix => '$apiHost/api/v1';

  Future<void> recordJingangClick(int jingangId) async {
    if (jingangId == 0) {
      throw Exception('jingangId is 0');
    }
    fetcher(url: '$apiPrefix/user/jingang-click', method: 'POST', body: {
      'jingangId': jingangId,
    });
  }
}
