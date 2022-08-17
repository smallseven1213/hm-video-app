import 'dart:async';
import 'dart:io' show Platform;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:uuid/uuid.dart';
import 'package:wgp_video_h5app/controllers/app_controller.dart';
import 'package:wgp_video_h5app/helpers/index.dart';
import 'package:wgp_video_h5app/providers/index.dart';

class RegisterException implements Exception {
  final String? _message;
  RegisterException([this._message]);
  @override
  String toString() {
    if (_message == null) return "Exception";
    if (_message == "01") return "不存在";
    if (_message == "02") return "未預期的檔案格式";
    if (_message == "03") return "未預期的資料格式";
    if (_message == "04") return "驗證未通過";
    if (_message == "05") return "請求太頻繁";
    if (_message == "06") return "驗證碼錯誤";
    if (_message == "40000") return "帳號已存在";
    return "註冊失敗";
  }
}

class AuthProvider extends BaseProvider {
  @override
  void onInit() {
    httpClient.baseUrl = '${AppController.cc.endpoint.getApi()}/public/auth';
  }

  static FutureOr<Request<T?>> authenticator<T>(Request<T?> request) async {
    var provider = Get.find<AuthProvider>();
    var controller = Get.find<AppController>();
    var token = controller.token.isEmpty
        ? await provider.guestLogin()
        : controller.token;
    controller.login(token);
    request.headers['Authorization'] = 'Bearer $token';
    // print('token $token');
    // print('token ${request.headers}');
    return request;
  }

  static Future<String> getToken<T>() async {
    var provider = Get.find<AuthProvider>();
    var controller = Get.find<AppController>();
    var token = controller.token.isEmpty
        ? await provider.guestLogin()
        : controller.token;
    controller.login(token);
    return 'Bearer $token';
  }

  Future<String> guestLogin({String? invitationCode, String? agentCode}) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    var agentCode = Get.find<AppController>().agentCode;
    invitationCode = Get.find<AppController>().invitationCode;
    var registerDeviceGuid = const Uuid().v4();
    if (!kIsWeb) {
      if (Platform.isAndroid) {
        registerDeviceGuid =
            (await (deviceInfo.androidInfo)).androidId.toString();
      } else if (Platform.isIOS) {
        registerDeviceGuid =
            (await (deviceInfo.iosInfo)).identifierForVendor.toString();
      }
    }
    var registerDeviceType = isWeb()
        ? 'H5'
        : isAndroid()
            ? 'ANDROID'
            : isIOS()
                ? 'IOS'
                : 'H5';
    if (!RegExp('[0-9A-Za-z]{6}').hasMatch(invitationCode)) {
      invitationCode = null;
    }
    try {
      var value = await post('/auth/guest/register', {
        'registerDeviceType': registerDeviceType,
        'registerDeviceGuid': registerDeviceGuid,
        "invitationCode": invitationCode,
        "agentCode": agentCode,
      });
      var res = (value.body as Map<String, dynamic>);
      if (res['code'] != '00') {
        return '';
      }
      int uid = res['data']['uid'];
      value = await post('/auth/guest/login', {
        "uid": uid,
      });
      res = (value.body as Map<String, dynamic>);
      if (res['code'] != '00') {
        return '';
      }
      return res['data']['token'];
    } catch (err) {
      print(err);
    }
    return '';
  }

  Future<String> getLoginCode(String authorization) async {
    var value = await get('/auth/code', headers: {
      "authorization": 'bearer $authorization',
    });
    var res = (value.body as Map<String, dynamic>);
    if (res['code'] != '00') {
      return '';
    }
    return res['data']['code'];
  }

  Future<String> loginByCode(String code) async {
    var value = await post('/auth/code', {"code": code});
    var res = (value.body as Map<String, dynamic>);
    if (res['code'] != '00') {
      return '';
    }
    return res['data']['token'];
  }

  Future<String?> registerByPhone(
      {required String phoneNumber,
      required String pin,
      String invitationCode = ''}) async {
    var registerIp = '0.0.0.0';
    var uid = (await Get.find<UserProvider>().getCurrentUser()).uid;
    var value = await post('/auth/phone/register', {
      'phoneNumber': phoneNumber,
      'pin': pin,
      'uid': uid,
      'invitationCode': invitationCode,
      'registerIp': registerIp,
    });
    var res = (value.body as Map<String, dynamic>);
    if (res['code'] != '00') {
      throw RegisterException(res['code']);
      return null;
    }
    // print(res['data']);
    return res['data']['token'];
  }

  Future<String?> register({
    required String username,
    required String password,
    String invitationCode = '',
  }) async {
    var registerIp = '0.0.0.0';
    var uid = (await Get.find<UserProvider>().getCurrentUser()).uid;
    var value = await post('/auth/register', {
      'username': username,
      'password': password,
      'uid': uid,
      'invitationCode': invitationCode,
      'registerIp': registerIp,
    });
    var res = (value.body as Map<String, dynamic>);
    if (res['code'] != '00') {
      throw RegisterException(res['code']);
      // return null;
    }
    return null;
  }

  Future<String?> login({
    required String username,
    required String password,
  }) async {
    var value = await post('/auth/login', {
      'username': username,
      'password': password,
    });
    var res = (value.body as Map<String, dynamic>);
    if (res['code'] != '00') {
      return null;
    }
    // print(res['data']);
    return res['data']['token'];
  }
}
