import 'package:get/get.dart';
import 'package:shared/services/platform_service.app.dart'
    if (dart.library.html) 'package:shared/services/platform_service.web.dart'
    as app_platform_ervice;

import '../models/color_keys.dart';

class SystemConfigController extends GetxController {
  // 使用Rx类型封装属性，以便能够监听它们的变化
  var appColors = <ColorKeys, dynamic>{}.obs;
  var apiHost = Rxn<String>();
  var vodHost = Rxn<String>();
  var imgHost = Rxn<String>();
  var project = 'STT'.obs; // 默认值
  var agentCode = ''.obs; // 之后可以设置
  var version = '--'.obs; // 默认值
  var isMaintenance = false.obs;
  var userDevice = ''.obs; // 之后可以设置
  var dlJsonHostList = <String>[].obs;
  var timeout = 5000.obs;
  var authToken = ''.obs;

  @override
  void onInit() {
    super.onInit();
    project.value =
        const String.fromEnvironment('PROJECT', defaultValue: 'STT');
    version.value = const String.fromEnvironment('VERSION', defaultValue: '--');
    agentCode.value = app_platform_ervice.AppPlatformService().getHost();
    userDevice.value = GetPlatform.isWeb
        ? 'H5'
        : GetPlatform.isAndroid
            ? 'ANDROID'
            : GetPlatform.isIOS
                // ? 'IOS'
                ? 'ANDROID'
                : 'H5';
  }

  // 设置方法
  void setDlJsonHosts(List<String> hosts) {
    dlJsonHostList.value = hosts;
  }

  void setApiHost(String host) {
    apiHost.value = host;
    // apiHost.value = 'https://auth-api.hmtech-dev.com';
  }

  void setVodHost(String host) {
    vodHost.value = host;
  }

  void setImageHost(String host) {
    imgHost.value = host;
  }

  void setMaintenance(bool status) {
    isMaintenance.value = status;
  }

  void setColors(Map<ColorKeys, dynamic> colors) {
    appColors.value = colors;
  }
}
