import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../controllers/system_config_controller.dart';
import '../models/block_vod.dart';
import '../models/publisher.dart';
import '../models/vod.dart';
import '../utils/fetcher.dart';

final logger = Logger();

class PublisherApi {
  static final PublisherApi _instance = PublisherApi._internal();

  PublisherApi._internal();

  factory PublisherApi() {
    return _instance;
  }

  final SystemConfigController _systemConfigController =
      Get.find<SystemConfigController>();

  String get apiHost => _systemConfigController.apiHost.value!;
  String get apiPrefix => '$apiHost/public/publishers';

  Future<List<Publisher>> getManyBy(
      {required int page, String? name, int? sortBy}) async {
    var res = await fetcher(
        url:
            '$apiHost/api/v1/publisher?page=$page&limit=48&name=$name&isSortByVideos=${sortBy ?? 0}');
    if (res.data['code'] != '00') {
      return [];
    }
    return List.from((res.data['data']['data'] as List<dynamic>)
        .map((e) => Publisher.fromJson(e)));
  }

  Future<Publisher> getOne(int publisherId) async {
    var res = await fetcher(url: '$apiPrefix/publisher?id=$publisherId');
    if (res.data['code'] != '00') {
      return Publisher(0, '出版商', '');
    }
    return Publisher.fromJson(res.data['data']);
  }

  Future<BlockVod> getManyLatestVodBy(
      {int page = 1, int limit = 10, required int publisherId}) async {
    var res = await fetcher(
        url:
            '$apiPrefix/publisher/latest?id=$publisherId&page=$page&limit=$limit');
    if (res.data['code'] != '00') {
      return BlockVod([], 0);
    }

    return BlockVod(
        List.from((res.data['data']['data'] as List<dynamic>)
            .map((e) => Vod.fromJson(e))
            .toList()),
        res.data['data']['total'] ?? limit * (page + 1));
  }

  Future<BlockVod> getManyHottestVodBy(
      {int page = 1, int limit = 10, required int publisherId}) async {
    var res = await fetcher(
        url:
            '$apiPrefix/publisher/hottest?id=$publisherId&page=$page&limit=$limit');

    if (res.data['code'] != '00') {
      return BlockVod([], 0);
    }

    return BlockVod(
        List.from((res.data['data']['data'] as List<dynamic>)
            .map((e) => Vod.fromJson(e))
            .toList()),
        res.data['data']['total'] ?? limit * (page + 1));
  }

  Future<List<Publisher>> getRecommend() async {
    var res = await fetcher(
        url: '$apiHost/api/v1/publisher?page=1&limit=100&isRecommend=true');
    if (res.data['code'] != '00') {
      return [];
    }
    List<Publisher> publishers = res.data['data']['data']
        .map<Publisher>((e) => Publisher.fromJson(e))
        .toList();
    return publishers;
  }
}
