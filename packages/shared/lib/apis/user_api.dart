import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../models/actor.dart';
import '../models/hm_api_response.dart';
import '../models/hm_api_response_with_data.dart';
import '../models/user.dart';
import '../models/user_promote.dart';
import '../models/user_promote_record.dart';
import '../models/user_promote_with_totalcount.dart';
import '../models/user_withdrawal_data.dart';
import '../services/system_config.dart';
import '../utils/fetcher.dart';

final systemConfig = SystemConfig();

class UserApi {
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

  //withdraw資訊
  Future<List> getUserWithdrawalRecord({
    int page = 1,
    int limit = 20,
    int? remittanceType,
    int? status,
    String? startedAt,
    String? endedAt,
  }) {
    String path = '${systemConfig.apiHost}/user/withdrawal';
    Map qs = <String, dynamic>{};
    if (page != 1) {
      qs['page'] = page;
    }
    if (limit != 20) {
      qs['limit'] = limit;
    }
    if (remittanceType != null) {
      qs['remittanceType'] = remittanceType;
    }
    if (status != null) {
      qs['status'] = status;
    }
    if (startedAt != null) {
      qs['startedAt'] = startedAt;
    }
    if (endedAt != null) {
      qs['endedAt'] = endedAt;
    }
    if (qs.isNotEmpty) {
      path += '?';
      path += qs.entries.map((e) => '${e.key}=${e.value}').join('&');
    }

    return fetcher(url: path, method: 'GET', shouldValidate: true)
        .then((value) {
      var res = (value.data as Map<String, dynamic>);
      List record =
          List.from((res['data']['data'] as List<dynamic>).map((e) => e));
      return record;
    });
    ;
    /*
    return fetcher(url: path, method: 'GET').then((value) {
      var res = (value.data as Map<String, dynamic>);
      List record =
          List.from((res['data']['data'] as List<dynamic>).map((e) => e));
      return record;
    });
    */
  }

  // 更新使用者pin資料
  Future<void> updatePaymentPin(String paymentPin) async {
    var value = await fetcher(
        url: '${systemConfig.apiHost}/user/paymentPin',
        method: 'PUT',
        body: {
          'paymentPin': paymentPin,
        });
    var res = (value.data as Map<String, dynamic>);
    if (res['code'] != '00') {
      throw Exception(res['message']);
    }
  }

  Future<String> getLinkCode() =>
      fetcher(url: '/auth/code', method: 'GET').then((value) {
        var res = (value.data as Map<String, dynamic>);
        if (res['code'] != '00') {
          return '';
        }
        return res['data']['data']['code'];
      });

  Future<HMApiResponse> getPlayHistory() =>
      fetcher(url: '${systemConfig.apiHost}/user/watchRecord').then((value) {
        // var res = (value.body as Map<String, dynamic>);

        // if (res['code'] != '00') {
        //   return BlockVod([], 0);
        // }
        // List<Vod> vods = List.from(
        //     (res['data'] as List<dynamic>).map((e) => Vod.fromJson(e)));
        // return BlockVod(
        //   vods,
        //   vods.length,
        // );

        return value.data;
      });
  Future<void> addPlayHistory(int videoId) => fetcher(
      url: '${systemConfig.apiHost}/user/watchRecord',
      method: 'POST',
      body: {'videoId': videoId});

  Future<void> deletePlayHistory(List<int> videoId) => fetcher(
      url:
          '${systemConfig.apiHost}/user/watchRecord?videoId=${videoId.join(',')}',
      method: 'DELETE');

  Future<void> addFavoriteVod(int vodId) => fetcher(
      url: '${systemConfig.apiHost}/user/collectRecord',
      method: 'POST',
      body: {'videoId': vodId});

  Future<void> deleteFavorite(List<int> vodId) => fetcher(
      url:
          '${systemConfig.apiHost}/user/collectRecord?videoId=${vodId.join(',')}',
      method: 'DELETE');

  Future<void> deleteActorFavorite(List<int> vodId) => fetcher(
      url:
          '${systemConfig.apiHost}/user/actorCollectRecord?actorId=${vodId.join(',')}',
      method: 'DELETE');

  Future<HMApiResponse> getFavorite() =>
      fetcher(url: '${systemConfig.apiHost}/user/collectRecord').then((value) {
        // var res = (value.data as Map<String, dynamic>);
        return value.data;
        // if (res['code'] != '00') {
        //   return BlockVod([], 0);
        // }
        // List<Vod> vods = List.from(
        //     (res['data'] as List<dynamic>).map((e) => Vod.fromJson(e)));
        // return BlockVod(
        //   vods,
        //   vods.length,
        // );
      });

  Future<void> addFavoriteActor(int actorId) => fetcher(
      url: '${systemConfig.apiHost}/user/actorCollectRecord',
      method: 'POST',
      body: {'actorId': actorId});

  Future<void> deleteFavoriteActor(List<int> actorId) => fetcher(
      url:
          '${systemConfig.apiHost}/user/actorCollectRecord?videoId=${actorId.join(',')}',
      method: 'DELETE');

  Future<List<Actor>> getFavoriteActor() => fetcher(
              url: '${systemConfig.apiHost}/user/actorCollectRecord',
              method: 'GET',
              shouldValidate: true)
          .then((value) {
        var res = (value.data as Map<String, dynamic>);
        if (res['code'] != '00') {
          return [];
        }
        List<Actor> actors = List.from(
            (res['data'] as List<dynamic>).map((e) => Actor.fromJson(e)));
        return actors;
      });

  Future<void> deleteTagFollowRecord(int tagId) => fetcher(
      url: '${systemConfig.apiHost}/user/tagFollowRecord?tagId=$tagId',
      method: 'DELETE');

  Future<void> addTagFollowRecord(int tagId) => fetcher(
      url: '${systemConfig.apiHost}/user/tagFollowRecord',
      method: 'POST',
      body: {'tagId': tagId});

  Future<void> deleteSupplierFollowRecord(int supplierId) => fetcher(
      url:
          '${systemConfig.apiHost}/user/supplierFollowRecord?supplierId=$supplierId',
      method: 'DELETE');

  Future<void> addSupplierFollowRecord(int supplierId) => fetcher(
      url: '${systemConfig.apiHost}/user/supplierFollowRecord',
      method: 'POST',
      body: {'supplierId': supplierId});

  Future<void> addUserEventRecord(String version) => fetcher(
      url: '${systemConfig.apiHost}/user/userEventRecord/enterHall',
      method: 'POST',
      body: {'version': version});

  Future<UserPromoteWithTotalCount> getPromoteRecord({
    int page = 1,
    int limit = 10,
  }) =>
      fetcher(
              url:
                  '${systemConfig.apiHost}/user/promoteRecord?page=$page&limit=$limit')
          .then((value) {
        var res = (value.data as Map<String, dynamic>);
        // print(res['data']);
        if (res['code'] != '00') {
          return UserPromoteWithTotalCount([], 0);
        }
        List<UserPromoteRecord> record = List.from(
            (res['data']['data'] as List<dynamic>)
                .map((e) => UserPromoteRecord.fromJson(e)));
        ;
        return UserPromoteWithTotalCount(record, res['data']['total']);
      });

  Future<UserPromote> getUserPromote() =>
      fetcher(url: '${systemConfig.apiHost}/user/userPromote').then((value) {
        var res = (value.data as Map<String, dynamic>);
        // print(res['data']);
        if (res['code'] != '00') {
          return UserPromote('', '', -1, -1);
        }
        return UserPromote.fromJson(res['data'] as Map<String, dynamic>);
      });

  Future<User> getCurrentUser() => fetcher(
              url:
                  '${systemConfig.apiHost}/user/info?ts=${DateTime.now().millisecondsSinceEpoch}')
          .then((value) {
        var res = (value.data as Map<String, dynamic>);
        // print(res['data']);
        if (res['code'] != '00') {
          return User('', 0, ['guest']);
        }
        return User.fromJson(res['data'] as Map<String, dynamic>);
      });

  Future<User> getCurrentUserWithdraw() => fetcher(
              url: '${systemConfig.apiHost}/user/withdrawal?page=1&limit=20',
              method: 'GET')
          .then((value) {
        var res = (value.data as Map<String, dynamic>);
        // print(res['data']);
        if (res['code'] != '00') {
          return User('', 0, ['guest']);
        }
        return User.fromJson(res['data'] as Map<String, dynamic>);
      });

  Future<void> updateNickname(String nickname) => fetcher(
      url: '${systemConfig.apiHost}/user/nickname',
      method: 'PUT',
      body: {'nickname': nickname});

  Future updatePassword(String origin, String newer) async {
    var value = await fetcher(
        url: '${systemConfig.apiHost}/user/password',
        method: 'PUT',
        body: {'password': origin, 'newPassword': newer});
    var res = (value.data as Map<String, dynamic>);
    return res;
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
