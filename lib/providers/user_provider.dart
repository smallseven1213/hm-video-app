import 'dart:convert';
import 'dart:io' show Platform;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:wgp_video_h5app/controllers/index.dart';
import 'package:wgp_video_h5app/helpers/index.dart';
import 'package:wgp_video_h5app/models/index.dart';
import 'package:wgp_video_h5app/models/user_promote_record.dart';
import 'package:wgp_video_h5app/providers/index.dart';

import '../models/user_promote.dart';

class UserProvider extends BaseProvider {
  @override
  void onInit() {
    httpClient.baseUrl = '${AppController.cc.endpoint.getApi()}/public/users';
    super.onInit();
  }

  Future<void> deleteTagFollowRecord(int tagId) =>
      delete('/user/tagFollowRecord?tagId=$tagId');

  Future<void> addTagFollowRecord(int tagId) =>
      post('/user/tagFollowRecord', {'tagId': tagId});

  Future<void> deleteSupplierFollowRecord(int supplierId) =>
      delete('/user/supplierFollowRecord?supplierId=$supplierId');

  Future<void> addSupplierFollowRecord(int supplierId) =>
      post('/user/supplierFollowRecord', {'supplierId': supplierId});

  Future<void> addUserEventRecord(String version) =>
      post('/user/userEventRecord/enterHall', {'version': version});

  Future<BlockUserPromoteRecord> getPromoteRecord({
    int page = 1,
    int limit = 10,
  }) =>
      get('/user/promoteRecord?page=$page&limit=$limit').then((value) {
        var res = (value.body as Map<String, dynamic>);
        // print(res['data']);
        if (res['code'] != '00') {
          return BlockUserPromoteRecord([], 0);
        }
        List<UserPromoteRecord> record = List.from(
            (res['data']['data'] as List<dynamic>)
                .map((e) => UserPromoteRecord.fromJson(e)));
        ;
        return BlockUserPromoteRecord(record, res['data']['total']);
      });

  Future<UserPromote> getUserPromote() =>
      get('/user/userPromote').then((value) {
        var res = (value.body as Map<String, dynamic>);
        // print(res['data']);
        if (res['code'] != '00') {
          return UserPromote('', '', -1, -1);
        }
        return UserPromote.fromJson(res['data'] as Map<String, dynamic>);
      });

  Future<User> getCurrentUser() => get('/user/info').then((value) {
        var res = (value.body as Map<String, dynamic>);
        // print(res['data']);
        if (res['code'] != '00') {
          return User('', 0, ['guest']);
        }
        return User.fromJson(res['data'] as Map<String, dynamic>);
      });

  Future<void> updateNickname(String nickname) async {
    var value = await put('/user/nickname', {'nickname': nickname});
    var res = (value.body as Map<String, dynamic>);
  }

  Future<void> updatePassword(String origin, String newer) async {
    var value =
        await put('/user/password', {'password': origin, 'newPassword': newer});
    var res = (value.body as Map<String, dynamic>);
  }

  // Future<List<UserPointRecord>> getUserPointRecords({
  //   required String userId,
  //   int page = 1,
  //   int limit = 100,
  // }) =>
  //     get('/point-record/list?page=$page&limit=$limit&userId=$userId')
  //         .then((value) {
  //       // print('$region, $page, $sortBy, $name');
  //       var res = (value.body as Map<String, dynamic>);
  //       // var total = res['data']['total'];
  //       // print((res['data']['data'] as List<dynamic>).length);
  //       if (res['code'] != '00') {
  //         return [];
  //       }
  //       return List.from((res['data']['data'] as List<dynamic>)
  //           .map((e) => UserPointRecord.fromJson(e)));
  //     });

  Future<String> getLinkCode() => get('/auth/code').then((value) {
        var res = (value.body as Map<String, dynamic>);
        // var total = res['data']['total'];
        // print((res['data']['data'] as List<dynamic>).length);
        if (res['code'] != '00') {
          return '';
        }
        return res['data']['data']['code'];
      });

  Future<BlockVod> getPlayHistory() => get('/user/watchRecord').then((value) {
        var res = (value.body as Map<String, dynamic>);
        // var total = res['data']['total'];
        // print((res['data']['data'] as List<dynamic>).length);
        if (res['code'] != '00') {
          return BlockVod([], 0);
        }
        List<Vod> vods = List.from(
            (res['data'] as List<dynamic>).map((e) => Vod.fromJson(e)));
        return BlockVod(
          vods,
          vods.length,
        );
      });
  Future<void> addPlayHistory(int videoId) =>
      post('/user/watchRecord', {'videoId': videoId});
  Future<void> deletePlayHistory(List<int> videoId) =>
      delete('/user/watchRecord?videoId=${videoId.join(',')}');

  Future<void> addFavoriteVod(int vodId) =>
      post('/user/collectRecord', {'videoId': vodId});
  Future<void> deleteFavorite(List<int> vodId) => delete(
        '/user/collectRecord?videoId=${vodId.join(',')}',
      );
  Future<void> deleteActorFavorite(List<int> vodId) => delete(
        '/user/actorCollectRecord?actorId=${vodId.join(',')}',
      );
  Future<BlockVod> getFavorite() => get('/user/collectRecord').then((value) {
        var res = (value.body as Map<String, dynamic>);
        if (res['code'] != '00') {
          return BlockVod([], 0);
        }
        List<Vod> vods = List.from(
            (res['data'] as List<dynamic>).map((e) => Vod.fromJson(e)));
        return BlockVod(
          vods,
          vods.length,
        );
      });

  Future<void> addFavoriteActor(int actorId) =>
      post('/user/actorCollectRecord', {'actorId': actorId});
  Future<void> deleteFavoriteActor(List<int> actorId) => delete(
        '/user/actorCollectRecord?videoId=${actorId.join(',')}',
      );
  Future<List<Actor>> getFavoriteActor() =>
      get('/user/actorCollectRecord').then((value) {
        var res = (value.body as Map<String, dynamic>);
        if (res['code'] != '00') {
          return [];
        }
        List<Actor> actors = List.from(
            (res['data'] as List<dynamic>).map((e) => Actor.fromJson(e)));
        return actors;
      });

  Future<int> loginRecord({
    required String version,
  }) async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      var registerDeviceGuid = const Uuid().v4();
      if (!kIsWeb) {
        if (Platform.isAndroid) {
          var info = await deviceInfo.androidInfo;
          registerDeviceGuid = json.encode(info.toMap());
        } else if (Platform.isIOS) {
          var info = await deviceInfo.iosInfo;
          registerDeviceGuid = json.encode(info.toMap());
        }
      } else {
        registerDeviceGuid =
            (await deviceInfo.webBrowserInfo).userAgent.toString();
      }
      // print('success $registerDeviceGuid');
      var registerDeviceType = isWeb()
          ? 'H5'
          : isAndroid()
              ? 'ANDROID'
              : isIOS()
                  ? 'IOS'
                  : 'H5';
      var user = await getCurrentUser();
      var res = await post('/user/userLoginRecord', {
        'uid': user.uid,
        'device': registerDeviceType,
        'version': version,
        'userAgent': registerDeviceGuid,
      });
      if (res.statusCode == 401) {
        return 0;
      }
      // print('success');
    } catch (err) {
      print(err);
    }
    return 1;
  }
}
