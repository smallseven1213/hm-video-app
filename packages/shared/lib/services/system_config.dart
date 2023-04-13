import 'package:get/get_utils/src/platform/platform.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared/models/color_keys.dart';

const env = String.fromEnvironment('ENV', defaultValue: 'prod');

class SystemConfig {
  static final SystemConfig _instance = SystemConfig._internal();

  // Color
  Map<ColorKeys, dynamic> appColors = {};

  // API ENDPOINT
  String apiHost = 'dev-sv.hmtech.site/$env/dl.json';
  String vodHost = 'https://dl.dlstt.com/$env/dl.json';
  String imgHost = 'https://dl.dlstt.com/$env/dl.json';

  // STT | GP | 51SS | SV
  String project = const String.fromEnvironment('PROJECT', defaultValue: 'STT');
  String agentCode = GetPlatform.isWeb
      ? '--' // window.location.host.split('.')[0]
      : const String.fromEnvironment('AgentCode',
          defaultValue: '--'); // 格式: 9L1O 之後改 --
  String version = const String.fromEnvironment('VERSION',
      defaultValue: '--'); // 格式: 22.0713.1.0 之後改 --
  bool isMaintenance = false;
  GetStorage box = GetStorage();
  String authToken = '';

  final userDevice = GetPlatform.isWeb
      ? 'H5'
      : GetPlatform.isAndroid
          ? 'ANDROID'
          : GetPlatform.isIOS
              ? 'IOS'
              : 'H5';

  List<String> vodHostList = [
    'https://dl.dlstt.com/$env/dl.json',
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

  void setColors(Map<ColorKeys, dynamic> colors) {
    appColors = colors;
  }
}
