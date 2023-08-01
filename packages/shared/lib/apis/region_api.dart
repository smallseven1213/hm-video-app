import 'package:logger/logger.dart';
import '../models/region.dart';
import '../services/system_config.dart';
import '../utils/fetcher.dart';

final systemConfig = SystemConfig();
final logger = Logger();

class RegionApi {
  static final RegionApi _instance = RegionApi._internal();

  RegionApi._internal();

  factory RegionApi() {
    return _instance;
  }

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

  Future<List<Region>> getRegions(int film) async {
    var res = await fetcher(
        url:
            '${systemConfig.apiHost}/public/regions/region/list/videoFilter?page=1&limit=10&film=$film');
    if (res.data['code'] != '00') {
      return [];
    }

    List<Region> regions = res.data['data']['data']
        .map<Region>((item) => Region.fromJson(item))
        .toList();
    return regions;
  }
}
