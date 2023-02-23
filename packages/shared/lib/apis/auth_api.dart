// import 'package:device_info_plus/device_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get_utils/src/platform/platform.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared/services/system_config.dart';
import 'package:shared/utils/fetcher.dart';
import 'package:uuid/uuid.dart';

final systemConfig = SystemConfig();

class AuthApi {
  // 訪客登入
  Future<Map<String, dynamic>> guestLogin(
      {String? invitationCode, String? agentCode}) async {
    String registerDeviceGuid = const Uuid().v4();
    String registerDeviceType = systemConfig.userDevice;
    GetStorage box = GetStorage();

    // 訪客註冊
    // 如果 GetPlatform.isWeb registerDeviceGuid 則用 uuid
    // 如果 GetPlatform.isAndroid registerDeviceGuid 則用 android id
    // 如果 GetPlatform.isIOS registerDeviceGuid 則用 ios info

    if (GetPlatform.isWeb) {
      if (box.hasData('register-device-guid')) {
        registerDeviceGuid = box.read('register-device-guid');
      } else {
        box.write('register-device-guid', registerDeviceGuid);
      }
    } else if (GetPlatform.isAndroid) {
      // registerDeviceGuid = await AndroidDeviceInfo().androidId;
    } else if (GetPlatform.isIOS) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      registerDeviceGuid =
          (await (deviceInfo.iosInfo)).identifierForVendor.toString();
    }

    try {
      var res = await fetcher(
        url: '${systemConfig.apiHost}/public/auth/auth/guest/register',
        method: 'POST',
        body: {
          'registerDeviceType': registerDeviceType,
          'registerDeviceGuid': registerDeviceGuid,
          'invitationCode': invitationCode,
          'agentCode': agentCode,
        },
      );
      print('res: $res');
      // if (res['code'] == '51633') {
      //   printError(info: '帳號建立失敗，裝置停用。');
      //   return '';
      // } else if (res['code'] != '00') {
      //   return '';
      // }

      return res.data;
    } catch (err) {
      print('guestLogin error: $err');
      return {};
    }
  }
}
