import 'dart:convert';

import 'package:live_core/models/room_rank.dart';
import 'package:live_core/utils/live_fetcher.dart';
import 'package:shared/controllers/system_config_controller.dart';
import 'package:shared/models/hm_api_response_with_data.dart';
import 'package:shared/utils/fetcher.dart';
import 'package:get/get.dart';

import '../libs/decryptAES256ECB.dart';
import '../models/live_api_response_base.dart';
import '../models/live_room.dart';
import '../models/room.dart';

class UserApi {
  static final UserApi _instance = UserApi._internal();
  SystemConfigController systemController = Get.find<SystemConfigController>();

  UserApi._internal();

  factory UserApi() {
    return _instance;
  }

  final SystemConfigController _systemConfigController =
      Get.find<SystemConfigController>();

  String get apiHost => _systemConfigController.apiHost.value!;

  Future<LiveApiResponseBase<List<Room>>> getRooms() async {
    var response = await fetcher(
      url: '$apiHost/roomlist',
    );

    LiveApiResponseBase<List<Room>> parsedResponse =
        LiveApiResponseBase.fromJson(
      response.data,
      (data) => (data as List).map((item) => Room.fromJson(item)).toList(),
    );

    return parsedResponse;
  }

  // get /room/detail?id=253
  Future<LiveApiResponseBase<Room>> getRoomDetail(int roomId) async {
    var response = await liveFetcher(
      url: 'https://dev-live-ext.hmtech-dev.com/room/detail?id=$roomId',
    );

    LiveApiResponseBase<Room> parsedResponse = LiveApiResponseBase.fromJson(
      response.data,
      (data) => Room.fromJson(data as Map<String, dynamic>),
    );

    return parsedResponse;
  }
}
