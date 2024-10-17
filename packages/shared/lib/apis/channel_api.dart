import 'package:get/get.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import '../controllers/system_config_controller.dart';
import '../models/banner_photo.dart';
import '../models/channel_info.dart';
import '../models/channel_shared_data.dart';
import '../models/game.dart';
import '../models/jingang.dart';
import '../models/slim_channel.dart';
import '../models/tag.dart';
import '../utils/fetcher.dart';

class ChannelApi {
  static final ChannelApi _instance = ChannelApi._internal();

  ChannelApi._internal();

  factory ChannelApi() {
    return _instance;
  }

  final SystemConfigController _systemConfigController =
      Get.find<SystemConfigController>();

  String get apiHost => _systemConfigController.apiHost.value!;
  String get apiPrefix => '$apiHost/public/channels';

  Future<List<SlimChannel>> getManyByLayout(int layoutId) async {
    var res = await fetcher(url: '$apiPrefix/channel/v2/list?layout=$layoutId');
    if (res.data['code'] != '00') {
      return [];
    }
    return List.from((res.data['data'] as List<dynamic>)
        .map((e) => SlimChannel.fromJson(e)));
  }

  // Get channel/v2/channelInfo?channelId=54
  Future<ChannelSharedData> getOneById(int channelId) async {
    const device = {
      'web': 1,
      'ios': 2,
      'android': 3,
    };
    int? deviceId = device['web'];

    if (!kIsWeb) {
      if (Platform.isIOS) {
        deviceId = device['ios'];
      } else {
        deviceId = device['android'];
      }
    }
    var res = await fetcher(
        url: '$apiHost/api/v1/channel/info?channelId=$channelId&device=$deviceId');
    if (res.data['code'] != '00') {
      return ChannelSharedData();
    }
    try {
      ChannelSharedData channelSharedData = ChannelSharedData(
        banner: List.from((res.data['data']['banner'] as List<dynamic>)
            .map((e) => BannerPhoto.fromJson(e))),
        jingang: Jingang.fromJson(res.data['data']['jingang']),
        tags: Tags.fromJson(res.data['data']['tagAreas']),
        blocks: List.from((res.data['data']['blocks'] as List<dynamic>)
            .map((e) => Blocks.fromJson(e))),
        gameBlocks: res.data['data']['gameBlocks'] != null ? List.from((res.data['data']['gameBlocks'] as List<dynamic>)
            .map((e) => Game.fromJson(e))) : [],
      );
      return channelSharedData;
    } catch (e) {
      // print('Error: ChannelSharedData: $e');
      return ChannelSharedData();
    }
    // ChannelSharedData channelSharedData = ChannelSharedData(
    //     banner: List.from((res.data['data']['banner'] as List<dynamic>)
    //         .map((e) => BannerPhoto.fromJson(e))),
    //     jingang: Jingang.fromJson(res.data['data']['jingang']),
    //     tags: Tags.fromJson(res.data['data']['tagAreas']),
    //     blocks: List.from((res.data['data']['blocks'] as List<dynamic>)
    //         .map((e) => Blocks.fromJson(e))));

    // return channelSharedData;
  }
}
