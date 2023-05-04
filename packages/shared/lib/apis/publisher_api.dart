import 'package:logger/logger.dart';

import '../models/block_vod.dart';
import '../models/publisher.dart';
import '../models/vod.dart';
import '../services/system_config.dart';
import '../utils/fetcher.dart';

final systemConfig = SystemConfig();
final logger = Logger();
final apiPrefixUrl = '${systemConfig.apiHost}/public/publishers';

class PublisherApi {
  static final PublisherApi _instance = PublisherApi._internal();

  PublisherApi._internal();

  factory PublisherApi() {
    return _instance;
  }

  Future<List<Publisher>> getManyBy(
      {required int page, String? name, int? sortBy}) async {
    var res = await fetcher(
        url:
            '$apiPrefixUrl/publisher/list?page=$page&limit=48&name=$name&isSortByVideos=${sortBy ?? 0}');
    if (res.data['code'] != '00') {
      return [];
    }
    return List.from((res.data['data']['data'] as List<dynamic>)
        .map((e) => Publisher.fromJson(e)));
  }

  Future<Publisher> getOne(int publisherId) async {
    var res = await fetcher(url: '$apiPrefixUrl/publisher?id=$publisherId');
    if (res.data['code'] != '00') {
      return Publisher(0, '出版商', '');
    }
    return Publisher.fromJson(res.data['data']);
  }

  Future<BlockVod> getManyLatestVodBy(
      {int page = 1, int limit = 10, required int publisherId}) async {
    var res = await fetcher(
        url:
            '$apiPrefixUrl/publisher/latest?id=$publisherId&page=$page&limit=$limit');
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
            '$apiPrefixUrl/publisher/hottest?id=$publisherId&page=$page&limit=$limit');

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
        url: '$apiPrefixUrl/publisher/list?page=1&limit=100&isRecommend=true');
    if (res.data['code'] != '00') {
      return [];
    }
    List<Publisher> publishers = res.data['data']['data']
        .map<Publisher>((e) => Publisher.fromJson(e))
        .toList();
    return publishers;
  }
}
