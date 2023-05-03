import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:game/models/user.dart';
import 'package:game/services/game_system_config.dart';
import 'package:uuid/uuid.dart';

import '../models/hm_api_response.dart';
import '../models/hm_api_response_with_data.dart';
import '../models/user_withdrawal_data.dart';
import '../utils/fetcher.dart';

final systemConfig = GameSystemConfig();

class UserApi {
  Future<User> getCurrentUser() => fetcher(
              url:
                  '${systemConfig.apiHost}/public/users/user/info?ts=${DateTime.now().millisecondsSinceEpoch}')
          .then((value) {
        var res = (value.data as Map<String, dynamic>);
        // print(res['data']);
        if (res['code'] != '00') {
          return User('', 0, ['guest']);
        }
        return User.fromJson(res['data'] as Map<String, dynamic>);
      });

  // 使用者登入紀錄
  Future<String> writeUserLoginRecord() async {
    var status = 'login'; // login | logout
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      var registerDeviceGuid = const Uuid().v4();
      if (!kIsWeb) {
        if (Platform.isAndroid) {
          var info = await deviceInfo.androidInfo;
          registerDeviceGuid = json.encode(info);
        } else if (Platform.isIOS) {
          var info = await deviceInfo.iosInfo;
          registerDeviceGuid = json.encode(info);
        }
      } else {
        registerDeviceGuid =
            (await deviceInfo.webBrowserInfo).userAgent.toString();
      }

      var res = await fetcher(
          url: '${systemConfig.apiHost}/public/users/user/userLoginRecord',
          method: 'POST',
          body: {
            'device': systemConfig.userDevice,
            'version': systemConfig.version,
            'userAgent': registerDeviceGuid,
          });

      if (res.statusCode == 401) {
        status = 'logout';
      }
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
    return status;
  }

  Future<UserWithdrawalData?> getUserGameWithdrawalData() async {
    var value = await fetcher(
        url: '${systemConfig.apiHost}/user/gameWithdrawal', method: 'GET');
    var res = (value.data as Map<String, dynamic>);
    if (res['code'] == '04') return null;
    return UserWithdrawalData.fromJson(res['data']);
  }

  // 提款申請, 帶入remittanceType,applyAmount與paymentPin共3個欄位, 去post to /user/withdrawal
  Future<HMApiResponse> applyWithdrawal(
      int remittanceType, String applyAmount, String paymentPin) async {
    var value = await fetcher(
        url: '${systemConfig.apiHost}/user/withdrawal',
        method: 'POST',
        body: {
          'remittanceType': remittanceType,
          'applyAmount': applyAmount,
          'paymentPin': paymentPin
        });
    var res = (value.data as Map<String, dynamic>);

    return HMApiResponse.fromJson(res);
  }

  // post到/user/paymentSecurity
  Future<HMApiResponse> updatePaymentSecurity(
      String account,
      int remittanceType,
      String bankName,
      String legalName,
      String branchName) async {
    var value = await fetcher(
        url: '${systemConfig.apiHost}/user/paymentSecurity',
        method: 'POST',
        body: {
          'account': account,
          'remittanceType': remittanceType,
          'bankName': bankName,
          'legalName': legalName,
          'branchName': branchName
        });

    var res = (value.data as Map<String, dynamic>);

    return HMApiResponse.fromJson(res);
  }

  // 檢查資金密碼，使用get call user/paymentPin?paymentPin=, function會將paymentPin帶入
  Future<HMApiResponseBaseWithDataWithData<bool>> checkPaymentPin(
      String paymentPin) async {
    var value = await fetcher(
        url: '${systemConfig.apiHost}/user/paymentPin?paymentPin=$paymentPin',
        method: 'GET');
    var res = (value.data as Map<String, dynamic>);

    return HMApiResponseBaseWithDataWithData<bool>.fromJson(res);
  }
}
