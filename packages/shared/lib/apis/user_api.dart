import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:shared/models/user_v2.dart';
import 'package:uuid/uuid.dart';
import 'package:http_parser/http_parser.dart' as http_parser;
import '../controllers/system_config_controller.dart';
import '../models/actor.dart';
import '../models/block_vod.dart';
import '../models/hm_api_response.dart';
import '../models/hm_api_response_with_data.dart';
import '../models/supplier.dart';
import '../models/user.dart';
import '../models/user_promote.dart';
import '../models/user_promote_record.dart';
import '../models/user_promote_with_totalcount.dart';
import '../models/user_withdrawal_data.dart';
import '../models/vod.dart';
import '../utils/fetcher.dart';

final logger = Logger();

class UserApi {
  static final UserApi _instance = UserApi._internal();

  UserApi._internal();

  factory UserApi() {
    return _instance;
  }

  final SystemConfigController _systemConfigController =
      Get.find<SystemConfigController>();

  String get apiHost => _systemConfigController.apiHost.value!;

  // 使用者登入紀錄
  Future writeUserLoginRecord() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      var registerDeviceGuid = const Uuid().v4();
      if (!kIsWeb) {
        if (Platform.isAndroid) {
          var info = await deviceInfo.androidInfo;
          registerDeviceGuid = json.encode(info.data);
        } else if (Platform.isIOS) {
          var info = await deviceInfo.iosInfo;
          registerDeviceGuid = json.encode(info.data);
        }
      } else {
        registerDeviceGuid =
            (await deviceInfo.webBrowserInfo).userAgent.toString();
      }

      fetcher(
        url: '$apiHost/public/users/user/userLoginRecord',
        method: 'POST',
        body: {
          'device': _systemConfigController.userDevice.value,
          'version': _systemConfigController.version.value,
          'userAgent': registerDeviceGuid,
        },
      );
    } catch (err) {
      if (kDebugMode) {
        logger.i(err);
      }
    }
  }

  // 使用者進入大廳（只記錄初次）
  Future writeUserEnterHallRecord() async {
    GetStorage box = GetStorage();
    if (box.read('entered') == null) {
      try {
        fetcher(
          url: '$apiHost/public/users/user/userEventRecord/enterHall',
          method: 'POST',
          body: {
            'version': _systemConfigController.version.value,
          },
        );
        box.write('entered', true);
      } catch (err) {
        if (kDebugMode) {
          logger.i(err);
        }
      }
    }
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
    String path = '$apiHost/user/withdrawal';
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
    var value =
        await fetcher(url: '$apiHost/user/paymentPin', method: 'PUT', body: {
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

  Future<HMApiResponseBaseWithDataWithData> getPlayHistory() =>
      fetcher(url: '$apiHost/public/users/user/watchRecord').then((value) {
        var result = HMApiResponseBaseWithDataWithData.fromJson(value.data);

        return result;
      });
  Future<void> addPlayHistory(int videoId) => fetcher(
      url: '$apiHost/public/users/user/watchRecord',
      method: 'POST',
      body: {'videoId': videoId});

  Future<void> deletePlayHistory(List<int> videoId) => fetcher(
      url:
          '$apiHost/public/users/user/watchRecord?videoId=${videoId.join(',')}',
      method: 'DELETE');

  Future<void> addFavoriteVideo(int vodId) => fetcher(
      url: '$apiHost/public/users/user/collectRecord',
      method: 'POST',
      body: {'videoId': vodId});

  Future<void> addFavoritSupplier(int supplierId) => fetcher(
      url: '$apiHost/public/users/user/supplierFollowRecord',
      method: 'POST',
      body: {'supplierId': supplierId});

  Future<void> deleteFavoriteVideo(List<int> vodId) => fetcher(
      url:
          '$apiHost/public/users/user/collectRecord?videoId=${vodId.join(',')}',
      method: 'DELETE');

  Future<void> deleteActorFavorite(List<int> vodId) => fetcher(
      url:
          '$apiHost/public/users/user/actorCollectRecord?actorId=${vodId.join(',')}',
      method: 'DELETE');

  Future<void> deleteSupplierFavorite(List<int> supplierId) => fetcher(
      url:
          '$apiHost/public/users/user/supplierFollowRecord?supplierId=${supplierId.join(',')}',
      method: 'DELETE');

  // 獲得視頻喜愛紀錄清單
  Future<BlockVod> getFavoriteVideo({int? film = 1}) async {
    var res = await fetcher(
        url: '$apiHost/public/users/user/collectRecord?film=$film');
    if (res.data['code'] != '00') {
      return BlockVod([], 0);
    }
    List<Vod> vods = List.from(
        (res.data['data'] as List<dynamic>).map((e) => Vod.fromJson(e)));
    return BlockVod(
      vods,
      vods.length,
    );
  }

  Future<void> addFavoriteActor(int actorId) => fetcher(
      url: '$apiHost/public/users/user/actorCollectRecord',
      method: 'POST',
      body: {'actorId': actorId});

  Future<void> deleteFavoriteActor(List<int> actorId) => fetcher(
      url:
          '$apiHost/public/users/user/actorCollectRecord?videoId=${actorId.join(',')}',
      method: 'DELETE');

  // 獲得視頻收藏紀錄清單
  Future<BlockVod> getVideoCollection({int? film = 1}) async {
    var res = await fetcher(
        url: '$apiHost/public/users/user/favoriteRecord?film=$film');
    if (res.data['code'] != '00') {
      return BlockVod([], 0);
    }
    List<Vod> vods = List.from(
        (res.data['data'] as List<dynamic>).map((e) => Vod.fromJson(e)));
    return BlockVod(
      vods,
      vods.length,
    );
  }

  Future<void> addVideoCollection(int videoId) => fetcher(
      url: '$apiHost/public/users/user/favoriteRecord',
      method: 'POST',
      body: {'videoId': videoId});

  Future<void> deleteVideoCollection(List<int> videoId) => fetcher(
      url:
          '$apiHost/public/users/user/favoriteRecord?videoId=${videoId.join(',')}',
      method: 'DELETE');

  // 獲得視頻購買紀錄清單
  Future<BlockVod> getVideoPurchaseRecord({int? film = 1}) async {
    var res =
        await fetcher(url: '$apiHost/api/v1/user/purchased-videos?film=$film');
    if (res.data['code'] != '00') {
      return BlockVod([], 0);
    }
    List<Vod> vods = List.from(
        (res.data['data'] as List<dynamic>).map((e) => Vod.fromJson(e)));
    return BlockVod(
      vods,
      vods.length,
    );
  }

  // 演員喜愛紀錄清單
  Future<List<Actor>> getFavoriteActor() async {
    var res = await fetcher(
        url: '$apiHost/public/users/user/actorCollectRecord',
        method: 'GET',
        shouldValidate: true);
    if (res.data['code'] != '00') {
      return [];
    }
    List<Actor> actors = List.from(
        (res.data['data'] as List<dynamic>).map((e) => Actor.fromJson(e)));
    return actors;
  }

  // UP主(供應商)喜愛紀錄清單
  Future<List<Supplier>> getFavoriteSupplier() async {
    var res = await fetcher(
        url: '$apiHost/public/users/user/supplierFollowRecord',
        method: 'GET',
        shouldValidate: true);
    if (res.data['code'] != '00') {
      return [];
    }
    List<Supplier> suppliers = List.from(
        (res.data['data'] as List<dynamic>).map((e) => Supplier.fromJson(e)));
    return suppliers;
  }

  Future<void> deleteTagFollowRecord(int tagId) => fetcher(
      url: '$apiHost/public/users/user/tagFollowRecord?tagId=$tagId',
      method: 'DELETE');

  Future<void> addTagFollowRecord(int tagId) => fetcher(
      url: '$apiHost/public/users/user/tagFollowRecord',
      method: 'POST',
      body: {'tagId': tagId});

  Future<void> deleteSupplierFollowRecord(int supplierId) => fetcher(
      url:
          '$apiHost/public/users/user/supplierFollowRecord?supplierId=$supplierId',
      method: 'DELETE');

  Future<void> addSupplierFollowRecord(int supplierId) => fetcher(
      url: '$apiHost/public/users/user/supplierFollowRecord',
      method: 'POST',
      body: {'supplierId': supplierId});

  Future<void> addUserEventRecord(String version) => fetcher(
      url: '$apiHost/public/users/user/userEventRecord/enterHall',
      method: 'POST',
      body: {'version': version});

  Future<UserPromoteWithTotalCount> getPromoteRecord({
    int page = 1,
    int limit = 10,
  }) =>
      fetcher(
              url:
                  '$apiHost/public/users/user/promoteRecord?page=$page&limit=$limit')
          .then((value) {
        var res = (value.data as Map<String, dynamic>);
        // logger.i(res['data']);
        if (res['code'] != '00') {
          return UserPromoteWithTotalCount([], 0);
        }
        List<UserPromoteRecord> record = List.from(
            (res['data']['data'] as List<dynamic>)
                .map((e) => UserPromoteRecord.fromJson(e)));

        return UserPromoteWithTotalCount(record, res['data']['total']);
      });

  Future<UserPromote> getUserPromote() =>
      fetcher(url: '$apiHost/public/users/user/userPromote').then((value) {
        var res = (value.data as Map<String, dynamic>);
        // logger.i(res['data']);
        if (res['code'] != '00') {
          return UserPromote('', '', -1, -1);
        }
        return UserPromote.fromJson(res['data'] as Map<String, dynamic>);
      });

  Future<User> getCurrentUser() => fetcher(
              url:
                  '$apiHost/api/v1/user/info?ts=${DateTime.now().millisecondsSinceEpoch}')
          .then((value) {
        var res = (value.data as Map<String, dynamic>);
        // logger.i(res['data']);
        if (res['code'] != '00') {
          return User('', 0, ['guest']);
        }
        return User.fromJson(res['data'] as Map<String, dynamic>);
      });

  Future<UserV2> getCurrentUserV2() => fetcher(
              url:
                  '$apiHost/api/v2/user/info?ts=${DateTime.now().millisecondsSinceEpoch}')
          .then((value) {
        var res = (value.data as Map<String, dynamic>);
        // logger.i(res['data']);
        if (res['code'] != '00') {
          return UserV2(
            uid: 0,
            roles: ['guest'],
            nickname: '',
            points: 0,
            isFree: false,
          );
        }
        return UserV2.fromJson(res['data'] as Map<String, dynamic>);
      });

  Future<User> getCurrentUserWithdraw() =>
      fetcher(url: '$apiHost/user/withdrawal?page=1&limit=20', method: 'GET')
          .then((value) {
        var res = (value.data as Map<String, dynamic>);
        // logger.i(res['data']);
        if (res['code'] != '00') {
          return User('', 0, ['guest']);
        }
        return User.fromJson(res['data'] as Map<String, dynamic>);
      });

  Future<void> updateNickname(String nickname) => fetcher(
      url: '$apiHost/api/v1/user/modify-nickname',
      method: 'PUT',
      body: {'nickname': nickname});

  Future updatePassword(String origin, String newer) async {
    var value = await fetcher(
        url: '$apiHost/public/users/user/password',
        method: 'PUT',
        body: {'password': origin, 'newPassword': newer});
    var res = (value.data as Map<String, dynamic>);
    return res;
  }

  Future<UserWithdrawalData?> getUserGameWithdrawalData() async {
    var value =
        await fetcher(url: '$apiHost/user/gameWithdrawal', method: 'GET');
    var res = (value.data as Map<String, dynamic>);
    if (res['code'] == '04') return null;
    return UserWithdrawalData.fromJson(res['data']);
  }

  // 提款申請, 帶入remittanceType,applyAmount與paymentPin共3個欄位, 去post to /user/withdrawal
  Future<HMApiResponse> applyWithdrawal(
      int remittanceType, String applyAmount, String paymentPin) async {
    var value =
        await fetcher(url: '$apiHost/user/withdrawal', method: 'POST', body: {
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
        url: '$apiHost/user/paymentSecurity',
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
        url: '$apiHost/user/paymentPin?paymentPin=$paymentPin', method: 'GET');
    var res = (value.data as Map<String, dynamic>);

    return HMApiResponseBaseWithDataWithData<bool>.fromJson(res);
  }

  // 上傳頭像給/users/user/avatar, 使用PUT call, 會將file帶入
  // 會傳回body.photoName給我並return String
  Future<String> uploadAvatar(XFile file) async {
    // ===FROM OLD
    var sid = const Uuid().v4();

    try {
      var form = dio.FormData.fromMap({
        'sid': sid,
        'photo': dio.MultipartFile.fromBytes(
          await file.readAsBytes(),
          filename: file.name,
          contentType:
              http_parser.MediaType.parse(file.mimeType ?? 'image/png'),
        ),
      });

      await fetcher(
        url: '$apiHost/public/photos/photo',
        method: 'POST',
        form: form,
      );
    } catch (error) {
      throw Exception('Failed to upload avatar: $error');
    }

    await fetcher(
        url: '$apiHost/api/v1/user/modify-avatar',
        method: 'PUT',
        body: {
          'photoName': sid,
        });

    return sid;

    // ===NEW
    // var sid = const Uuid().v4();

    // // Read the file as bytes
    // Uint8List fileBytes = await file.readAsBytes();

    // // Extract the content type
    // final contentType = file.mimeType ?? 'image/png';

    // // Create a MultipartFile from the file's content
    // final multipartFile = http.MultipartFile.fromBytes(
    //   'photo',
    //   fileBytes,
    //   filename: file.name,
    //   contentType: MediaType.parse(contentType),
    // );

    // // Create a FormData object
    // final formData = http.MultipartRequest(
    //   'PUT',
    //   Uri.parse('$apiHost/users/user/avatar'),
    // )
    //   ..fields['sid'] = sid
    //   ..files.add(multipartFile);

    // // Send the request
    // final response = await http.Response.fromStream(await formData.send());

    // if (response.statusCode == 200) {
    //   // Parse the response body
    //   final res = json.decode(response.body) as Map<String, dynamic>;
    //   return res['data']['photoName'];
    // } else {
    //   throw Exception('Failed to upload avatar: ${response.reasonPhrase}');
    // }
  }

  // user/purchase
  // id: 1 = 長視頻, 2 = 短視頻, 3 = 漫畫, 4 = 貼文
  Future<HMApiResponse> purchase(int type, int id) async {
    var value = await fetcher(
      url: '$apiHost/api/v1/user/purchase',
      method: 'POST',
      body: {
        'type': type,
        'id': id,
      },
    );
    var res = (value.data as Map<String, dynamic>);
    return HMApiResponse.fromJson(res);
  }
}
