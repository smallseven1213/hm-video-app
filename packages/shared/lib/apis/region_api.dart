import 'package:logger/logger.dart';
import '../models/region.dart';
import '../services/system_config.dart';
import '../utils/fetcher.dart';

final systemConfig = SystemConfig();
final logger = Logger();

class RegionApi {
  Future<List<Region>> getActorRegions() async {
    var res = await fetcher(
        url:
            '${systemConfig.apiHost}/public/regions/region/list?page=1&limit=100');
    if (res.data['code'] != '00') {
      return [];
    }

    List<Region> regions = res.data['data']['data']
        .map<Region>((item) => Region.fromJson(item))
        .toList();
    return regions;
  }

  Future<List<Region>> getRegions() async {
    var res = await fetcher(
        url:
            '${systemConfig.apiHost}/public/regions/region/list/videoFilter?page=1&limit=10');
    if (res.data['code'] != '00') {
      return [];
    }

    List<Region> regions = res.data['data']['data']
        .map<Region>((item) => Region.fromJson(item))
        .toList();
    return regions;
  }
}
