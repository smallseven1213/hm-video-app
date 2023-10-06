// import 'package:device_info_plus/device_info_plus.dart';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get_utils/src/platform/platform.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:shared/services/system_config.dart';
import 'package:shared/utils/fetcher.dart';
import 'package:uuid/uuid.dart';
import 'package:android_id/android_id.dart';
import '../models/index.dart';

final systemConfig = SystemConfig();
final logger = Logger();

class AuthApi {
  static final AuthApi _instance = AuthApi._internal();

  AuthApi._internal();

  factory AuthApi() {
    return _instance;
  }

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
      String androidId = await const AndroidId().getId() ?? 'Unknown ID';
      registerDeviceGuid = androidId;
      logger.i('👺👺 androidId2: $androidId');
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

  Future<HMApiResponseBaseWithDataWithData> register({
    required String username,
    required String password,
    required int uid,
    String invitationCode = '',
  }) async {
    var registerIp = '0.0.0.0';
    var res = await fetcher(
      url: '${systemConfig.apiHost}/public/auth/auth/register',
      method: 'POST',
      body: {
        'username': username,
        'password': password,
        'uid': uid,
        'registerIp': registerIp,
        'invitationCode': invitationCode
      },
    );
    try {
      return HMApiResponseBaseWithDataWithData.fromJson(res.data);
    } catch (e) {
      return HMApiResponseBaseWithDataWithData(
        code: 'FormatException',
        data: res.data,
      );
    }
  }

  Future<HMApiResponseBaseWithDataWithData?> loginByCode(String code) async {
    try {
      var res = await fetcher(
          url: '${systemConfig.apiHost}/public/auth/auth/code',
          method: 'POST',
          body: {"code": code});
      return HMApiResponseBaseWithDataWithData.fromJson(res.data);
    } catch (err) {
      // return HMApiResponseBaseWithDataWithData.fromJson(res.data);
    }
    return null;
  }

  Future<HMApiResponseBaseWithDataWithData> getLoginCode() async {
    var res = await fetcher(
      url: '${systemConfig.apiHost}/public/auth/auth/code',
    );
    logger.i('getLoginCode: $res');
    return HMApiResponseBaseWithDataWithData.fromJson(res.data);
  }

  Future<String?> login({
    required String username,
    required String password,
  }) async {
    var value = await fetcher(
      url: '${systemConfig.apiHost}/public/auth/auth/v2/login',
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
