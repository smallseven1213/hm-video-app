import 'dart:html';

import 'package:get/get_utils/src/platform/platform.dart';
import 'package:get_storage/get_storage.dart';

const env = String.fromEnvironment('ENV', defaultValue: 'dev');

class SystemConfig {
  /**
   * 這裡應該會
   * dl.json的資訊，但如果整個系統只有一次需要用到dl.json，那就別加了
   * 然後再幫我填入正確的apiHost等資訊
   */
  static final SystemConfig _instance = SystemConfig._internal();

  String apiHost = 'https://dl.dlstt.com/$env/dl.json';
  String vodHost = 'https://dl.dlstt.com/$env/dl.json';
  String imgHost = 'https://dl.dlstt.com/$env/dl.json';

  // STT | GP | 51SS | SV
  String project = const String.fromEnvironment('PROJECT', defaultValue: 'STT');
  String agentCode = GetPlatform.isWeb
      ? window.location.host.split('.')[0]
      : const String.fromEnvironment('AgentCode', defaultValue: '--');
  String version = const String.fromEnvironment('VERSION',
      defaultValue: '22.0713.1.0'); // 格式: 22.0713.1.0 之後改 --
  bool isMaintenance = false;
  GetStorage box = GetStorage();
  final userDevice = GetPlatform.isWeb
      ? 'H5'
      : GetPlatform.isAndroid
          ? 'ANDROID'
          : GetPlatform.isIOS
              ? 'IOS'
              : 'H5';

  List<String> vodHostList = [
    'https://dl.dlstt.com/$env/dl.json1',
    'https://dl.0272pay.com/$env/dl.json',
  ];

  int timeout = 5000;

  factory SystemConfig() {
    return _instance;
  }

  SystemConfig._internal();

  // settle
  void setApiHost(String host) {
    apiHost = host;
  }

  void setVodHost(String host) {
    vodHost = host;
  }

  void setImageHost(String host) {
    imgHost = host;
  }

  void setMaintenance(bool status) {
    isMaintenance = status;
  }
}
