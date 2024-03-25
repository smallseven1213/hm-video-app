import 'package:live_core/controllers/live_system_controller.dart';
import 'package:live_core/models/room_rank.dart';
import 'package:live_core/utils/live_fetcher.dart';
import 'package:shared/controllers/system_config_controller.dart';
import 'package:get/get.dart';

import '../controllers/live_list_controller.dart';
import '../libs/decryptAES256ECB.dart';
import '../models/gift.dart';
import '../models/live_api_response_base.dart';
import '../models/live_api_response_list.dart';
import '../models/live_room.dart';
import '../models/live_user_detail.dart';
import '../models/room.dart';
import '../models/command.dart';

class LiveApi {
  static final LiveApi _instance = LiveApi._internal();
  SystemConfigController systemController = Get.find<SystemConfigController>();
  LiveSystemController liveSystemController = Get.find<LiveSystemController>();

  LiveApi._internal();

  factory LiveApi() {
    return _instance;
  }

  // 主播排行榜
  Future<LiveApiResponseList<Room>> getRooms({
    int page = 1,
    int perPage = 20,
    int status = 0,
    int chargeType = 0,
    SortType ranking = SortType.defaultSort,
    int followType = 0,
  }) async {
    var ranking0 = ranking.toString().split('.').last; // 更简洁的转换枚举到字符串

    var userApiHost = liveSystemController.liveApiHost.value;
    // const userApiHost = 'https://live-api.hmtech-dev.com/user/v1';
    var response = await liveFetcher(
      url:
          '$userApiHost/user/v1/room/list?page=$page&per_page=$perPage&status=$status&charge_type=$chargeType&ranking=$ranking0&follow=$followType',
    );

    if (response.data['data'].isEmpty) {
      return LiveApiResponseList<Room>(
        items: [],
        pagination:
            Pagination(currentPage: 0, lastPage: 0, perPage: 0, total: 0),
      );
    }

    return LiveApiResponseList<Room>.fromJson(
      response.data,
      (itemJson) => Room.fromJson(itemJson),
    );
  }

  Future<LiveApiResponseBase<LiveRoom?>> enterRoom(int pid) async {
    try {
      final liveApiHost = Get.find<LiveSystemController>().liveApiHostValue;
      var response = await liveFetcher(
        url: '$liveApiHost/enterroom',
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
      String decryptedData = apiResponse.data.pullurl.isNotEmpty
          ? decryptAES256ECB(apiResponse.data.pullurl)
          : "";

      return LiveApiResponseBase<LiveRoom>(
        code: apiResponse.code,
        data: LiveRoom(
          hid: apiResponse.data.hid,
          chattoken: apiResponse.data.chattoken,
          pid: apiResponse.data.pid,
          pullurl: apiResponse.data.pullurl,
          pullUrlDecode: decryptedData.trim().trimRight(),
          amount: apiResponse.data.amount,
          follow: apiResponse.data.follow,
          commands: apiResponse.data.commands,
          languages: apiResponse.data.languages,
        ),
        // 下面測試用
        // pullUrlDecode:
        //     'rtmp://dev-live-ext.aizepin.com/live/yuki?txSecret=a0c69febcb0ce2d27c9c5696224f886b&txTime=6566B37B'),
        msg: apiResponse.msg,
      );
    } catch (e) {
      // Handle the exception
      rethrow;
    }
  }

  Future<LiveApiResponseBase<bool>> exitRoom() async {
    try {
      final liveApiHost = Get.find<LiveSystemController>().liveApiHostValue;
      var response = await liveFetcher(
        url: '$liveApiHost/exitroom',
        method: 'GET',
      );

      if (response.data["code"] != 200) {
        throw Exception('No response from server');
      }

      LiveApiResponseBase<bool> apiResponse = LiveApiResponseBase.fromJson(
        response.data,
        (data) => data == true,
      );

      return LiveApiResponseBase<bool>(
        code: apiResponse.code,
        data: apiResponse.data,
        msg: apiResponse.msg,
      );
    } catch (e) {
      // Handle the exception
      rethrow;
    }
  }

  Future<LiveApiResponseBase<RoomRank?>> getRank(int pid) async {
    try {
      final liveApiHost = Get.find<LiveSystemController>().liveApiHostValue;
      var response = await liveFetcher(
        url: '$liveApiHost/rank',
      );
      if (response != null) {
        LiveApiResponseBase<RoomRank> parsedResponse =
            LiveApiResponseBase.fromJson(
          response.data,
          (data) => RoomRank.fromJson(data as Map<String, dynamic>),
        );

        return parsedResponse;
      }

      return LiveApiResponseBase<RoomRank?>(
        code: 0,
        data: null,
        msg: 'Error occurred while fetching room rank',
      );
    } catch (e) {
      // Handle the exception
      return LiveApiResponseBase<RoomRank?>(
        code: 0,
        data: null,
        msg: 'Error occurred while fetching room rank',
      );
    }
  }

  Future<LiveApiResponseBase<List<Gift>>> getGifts() async {
    final liveApiHost = Get.find<LiveSystemController>().liveApiHostValue;
    var response = await liveFetcher(
      url: '$liveApiHost/giftlist',
    );

    LiveApiResponseBase<List<Gift>> parsedResponse =
        LiveApiResponseBase.fromJson(
      response.data,
      (data) => (data as List).map((item) {
        return Gift.fromJson(item);
      }).toList(),
    );

    return parsedResponse;
  }

  Future<LiveApiResponseBase<bool>> sendGift(
      int gid, double amount, int quantity) async {
    final liveApiHost = Get.find<LiveSystemController>().liveApiHostValue;
    var response = await liveFetcher(
      url: '$liveApiHost/gift',
      method: 'POST',
      body: {'gid': gid, 'amount': amount, 'quantity': quantity},
    );

    LiveApiResponseBase<bool> parsedResponse = LiveApiResponseBase.fromJson(
      response.data,
      (data) => data == true,
    );

    return parsedResponse;
  }

  Future<LiveApiResponseBase<List<Command>>> getCommands() async {
    final liveApiHost = Get.find<LiveSystemController>().liveApiHostValue;
    var response = await liveFetcher(
      url: '$liveApiHost/user/v1/cmdlist',
    );

    LiveApiResponseBase<List<Command>> parsedResponse =
        LiveApiResponseBase.fromJson(
      response.data,
      (data) => (data as List).map((item) => Command.fromJson(item)).toList(),
    );

    return parsedResponse;
  }

  Future<LiveApiResponseBase> sendCommand(int cid, double amount) async {
    final liveApiHost = Get.find<LiveSystemController>().liveApiHostValue;
    var response = await liveFetcher(
      url: '$liveApiHost/cmd',
      method: 'POST',
      body: {
        'cid': cid,
        'amount': amount,
      },
    );

    LiveApiResponseBase parsedResponse = LiveApiResponseBase.fromJson(
      response.data,
      (data) => data,
    );

    return parsedResponse;
  }

  // Get /user/detail
  Future<LiveApiResponseBase<LiveUserDetail>> getUserDetail() async {
    final liveApiHost = Get.find<LiveSystemController>().liveApiHostValue;
    var response = await liveFetcher(
      url: '$liveApiHost/user/v1/user/detail',
    );

    LiveApiResponseBase<LiveUserDetail> parsedResponse =
        LiveApiResponseBase.fromJson(
      response.data,
      (data) => LiveUserDetail.fromJson(data as Map<String, dynamic>),
    );

    return parsedResponse;
  }

  // 購買單次門票
  Future<LiveApiResponseBase<bool>> buyTicket(int pid) async {
    final liveApiHost = Get.find<LiveSystemController>().liveApiHostValue;
    var response = await liveFetcher(
      url: '$liveApiHost/buyticket?pid=$pid',
      method: 'GET',
    );

    LiveApiResponseBase<bool> parsedResponse = LiveApiResponseBase.fromJson(
      response.data,
      (data) => data == true,
    );

    return parsedResponse;
  }

  Future<LiveApiResponseBase<bool>> buyWatch(
      int pid, bool userIsAutoRenew) async {
    final liveApiHost = Get.find<LiveSystemController>().liveApiHostValue;
    var response = await liveFetcher(
      url: '$liveApiHost/buywatch?pid=$pid&autobuy=$userIsAutoRenew',
      method: 'GET',
    );

    LiveApiResponseBase<bool> parsedResponse = LiveApiResponseBase.fromJson(
      response.data,
      (data) => data == true,
    );

    return parsedResponse;
  }

  Future<LiveApiResponseBase<bool>> follow(int hid) async {
    final liveApiHost = Get.find<LiveSystemController>().liveApiHostValue;
    var response = await liveFetcher(
      url: '$liveApiHost/user/v1/follow?hid=$hid',
      method: 'GET',
    );

    LiveApiResponseBase<bool> parsedResponse = LiveApiResponseBase.fromJson(
      response.data,
      (data) => data == true,
    );

    return parsedResponse;
  }

  Future<LiveApiResponseBase<bool>> unfollow(int hid) async {
    final liveApiHost = Get.find<LiveSystemController>().liveApiHostValue;
    var response = await liveFetcher(
      url: '$liveApiHost/user/v1/unfollow?hid=$hid',
      method: 'GET',
    );

    LiveApiResponseBase<bool> parsedResponse = LiveApiResponseBase.fromJson(
      response.data,
      (data) => data == true,
    );

    return parsedResponse;
  }
}
