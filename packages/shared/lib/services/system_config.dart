import 'package:get/get_utils/src/platform/platform.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/services/platform_service.app.dart'
    if (dart.library.html) 'package:shared/services/platform_service.web.dart'
    as app_platform_ervice;

const env = String.fromEnvironment('ENV', defaultValue: 'prod');

class SystemConfig {
  static final SystemConfig _instance = SystemConfig._internal();

  // Color
  Map<ColorKeys, dynamic> appColors = {};
  // API ENDPOINT
  // String apiHost = 'dl.dlsv.net/$env/dl.json';
  // String vodHost = 'https://dl.dlsv.net/$env/dl.json';
  // String imgHost = 'https://dl.dlsv.net/$env/dl.json';
  String? apiHost;
  String? vodHost;
  String? imgHost;

  // STT | GP | 51SS | SV
  String project = const String.fromEnvironment('PROJECT', defaultValue: 'STT');
  String agentCode = app_platform_ervice.AppPlatformService().getHost();
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
              // ? 'IOS'
              ? 'ANDROID'
              : 'H5';

  List<String> vodHostList = [
    'https://dl.dlgs.app/$env/dl.json',
    'https://dl.dlgs.one/$env/dl.json',
    'https://dl.dlgs.info/$env/dl.json',
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
