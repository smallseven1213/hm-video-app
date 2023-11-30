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

class LiveApi {
  static final LiveApi _instance = LiveApi._internal();
  SystemConfigController systemController = Get.find<SystemConfigController>();

  LiveApi._internal();

  factory LiveApi() {
    return _instance;
  }

  Future<LiveApiResponseBase<List<Room>>> getRooms() async {
    var response = await liveFetcher(
      url: 'https://dev-live-ext.hmtech-dev.com/roomlist',
    );

    LiveApiResponseBase<List<Room>> parsedResponse =
        LiveApiResponseBase.fromJson(
      response.data,
      (data) => (data as List).map((item) => Room.fromJson(item)).toList(),
    );

    return parsedResponse;
  }

  Future<LiveApiResponseBase<LiveRoom>> enterRoom(int pid) async {
    try {
      var response = await liveFetcher(
        url: 'https://dev-live-ext.hmtech-dev.com/enterroom',
        method: 'POST',
        body: {
          'pid': pid,
        },
      );

      if (response.data["code"] != 200) {
        throw Exception('No response from server');
      }

      // Map<String, dynamic> jsonResponse = jsonDecode(response.data);

      LiveApiResponseBase<LiveRoom> apiResponse = LiveApiResponseBase.fromJson(
        response.data,
        (data) => LiveRoom.fromJson(data as Map<String, dynamic>),
      );

      // Assuming that the `data` field in the response is a JSON string
      String decryptedData = decryptAES256ECB(apiResponse.data.pullurl);

      return LiveApiResponseBase<LiveRoom>(
        code: apiResponse.code,
        data: LiveRoom(
          chattoken: apiResponse.data.chattoken,
          pid: apiResponse.data.pid,
          pullurl: apiResponse.data.pullurl,
          pullUrlDecode: decryptedData.trim().trimRight(),
        ),
        // 下面測試用
        // pullUrlDecode:
        //     'rtmp://dev-live-ext.aizepin.com/live/yuki?txSecret=a0c69febcb0ce2d27c9c5696224f886b&txTime=6566B37B'),
        msg: apiResponse.msg,
      );
    } catch (e) {
      // Handle the exception
      throw e;
    }
  }

  Future<LiveApiResponseBase<RoomRank>> getRank() async {
    var response = await liveFetcher(
      url: 'https://dev-live-ext.hmtech-dev.com/rank',
    );

    LiveApiResponseBase<RoomRank> parsedResponse = LiveApiResponseBase.fromJson(
      response.data,
      (data) => RoomRank.fromJson(data as Map<String, dynamic>),
    );

    return parsedResponse;
  }
}
