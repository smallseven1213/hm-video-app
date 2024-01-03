import 'package:live_core/utils/live_fetcher.dart';
import 'package:shared/controllers/system_config_controller.dart';
import 'package:shared/utils/fetcher.dart';
import 'package:get/get.dart';

import '../controllers/live_system_controller.dart';
import '../models/live_api_response_base.dart';
import '../models/room.dart';
import '../models/streamer.dart';

const userApiHost = 'https://live-api.hmtech-dev.com/user/v1';

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

  Future<LiveApiResponseBase<List<Streamer>>> getFollows() async {
    final liveApiHost = Get.find<LiveSystemController>().liveApiHostValue;
    var response = await liveFetcher(
      url: '$liveApiHost/user/v1/user/follows',
    );

    LiveApiResponseBase<List<Streamer>> parsedResponse =
        LiveApiResponseBase.fromJson(
      response.data,
      (data) => (data as List).map((item) => Streamer.fromJson(item)).toList(),
    );

    return parsedResponse;
  }

  // 帶入hid(stream id), 取得有沒有追蹤, 回傳boolean
  Future<LiveApiResponseBase<bool>> getIsFollow(int hid) async {
    final liveApiHost = Get.find<LiveSystemController>().liveApiHostValue;
    var response = await liveFetcher(
      url: '$liveApiHost/user/v1/user/isfollow?hid=$hid',
    );

    LiveApiResponseBase<bool> parsedResponse = LiveApiResponseBase.fromJson(
      response.data,
      (data) => data as bool,
    );

    return parsedResponse;
  }
}
