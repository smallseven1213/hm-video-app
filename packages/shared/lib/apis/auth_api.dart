// import 'package:device_info_plus/device_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get_utils/src/platform/platform.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared/services/system_config.dart';
import 'package:shared/utils/fetcher.dart';
import 'package:uuid/uuid.dart';
import '../models/index.dart';

final systemConfig = SystemConfig();

class AuthApi {
  // 訪客登入
  Future<HMApiResponseBaseWithDataWithData> guestLogin({
    String? invitationCode,
  }) async {
    String registerDeviceGuid = const Uuid().v4();
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    GetStorage box = systemConfig.box;

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
      // get android id
      registerDeviceGuid = (await deviceInfo.androidInfo).data['id'];
    } else if (GetPlatform.isIOS) {
      registerDeviceGuid =
          (await (deviceInfo.iosInfo)).identifierForVendor.toString();
    }

    var response = await fetcher(
      url: '${systemConfig.apiHost}/public/auth/auth/guest/register',
      method: 'POST',
      body: {
        'registerDeviceType': systemConfig.userDevice,
        'registerDeviceGuid': registerDeviceGuid,
        'invitationCode': invitationCode,
        'agentCode': systemConfig.agentCode,
      },
    );

    return HMApiResponseBaseWithDataWithData.fromJson(response.data);

    // try {
    //   var response = await fetcher(
    //     url: '${systemConfig.apiHost}/public/auth/auth/guest/register',
    //     method: 'POST',
    //     body: {
    //       'registerDeviceType': systemConfig.userDevice,
    //       'registerDeviceGuid': registerDeviceGuid,
    //       'invitationCode': invitationCode,
    //       'agentCode': systemConfig.agentCode,
    //     },
    //   );
    //   return response.data;
    //   // if (res['code'] != '00') {
    //   //   return HMApiResponse(
    //   //     code: res['code'],
    //   //     message: res['code'] == '51633' ? '帳號建立失敗，裝置停用。' : '帳號建立失敗。',
    //   //   );
    //   // }
    //   // return HMApiResponse(
    //   //   code: res['code'],
    //   //   message: '帳號建立成功。',
    //   // );
    // } catch (err) {
    //   // return HMApiResponse(
    //   //   code: '01',
    //   //   message: '帳號建立失敗。',
    //   // );
    //   // throw error
    // }
  }

  Future<String?> register({
    required String username,
    required String password,
    // String invitationCode = '',
  }) async {
    // var registerIp = '0.0.0.0';
    // var uid = (await Get.find<UserProvider>().getCurrentUser()).uid;
    // var invitationCode = Get.find<AppController>().invitationCode;

    try {
      var response = await fetcher(
        url: '${systemConfig.apiHost}/public/auth/auth/register',
        method: 'POST',
        body: {
          'username': username,
          'password': password,
          'agentCode': systemConfig.agentCode,
        },
      );
      var res = (response.data as Map<String, dynamic>);
      if (res['code'] != '00') {
        return null;
      }
      return res['data']['token'];
    } catch (err) {
      return null;
    }
  }

  Future<String?> login({
    required String username,
    required String password,
  }) async {
    var value = await fetcher(
      url: '${systemConfig.apiHost}/public/auth/auth/login',
      method: 'POST',
      body: {
        'username': username,
        'password': password,
      },
    );
    var res = (value.data as Map<String, dynamic>);
    if (res['code'] != '00') {
      return null;
    }
    return res['data']['token'];
  }
}
